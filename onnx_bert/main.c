/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

/* auto generate by HHB_VERSION "3.2.2" */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef ONNX_BERT_BAREMETAL
#include <libgen.h>
#include <unistd.h>
#include "cmd_parse.h"
#include "io.h"
#endif

#include "shl_ref.h"
#include "tvm_registration.h"

#define MIN(x, y)           ((x) < (y) ? (x) : (y))
#define FILE_LENGTH         1028
#define SHAPE_LENGHT        128
#define FILE_PREFIX_LENGTH  (1028 - 2 * 128)

#define ONNX_BERT_INPUT_NUM   3
#define ONNX_BERT_OUTPUT_NUM  2
#define ONNX_BERT_SEQ_LEN     384

#ifdef ONNX_BERT_BAREMETAL
#ifndef ONNX_BERT_OUTPUT_TOLERANCE
#define ONNX_BERT_OUTPUT_TOLERANCE 0.04f
#endif

extern const unsigned char _binary_model_params_bin_start[];
extern const unsigned char _binary_model_params_bin_end[];
extern const unsigned char _binary_input_ids_bin_start[];
extern const unsigned char _binary_input_ids_bin_end[];
extern const unsigned char _binary_input_mask_bin_start[];
extern const unsigned char _binary_input_mask_bin_end[];
extern const unsigned char _binary_segment_ids_bin_start[];
extern const unsigned char _binary_segment_ids_bin_end[];
extern const unsigned char _binary_gold_output0_bin_start[];
extern const unsigned char _binary_gold_output0_bin_end[];
extern const unsigned char _binary_gold_output1_bin_start[];
extern const unsigned char _binary_gold_output1_bin_end[];
#endif

void *csinn_(char *params);
void csinn_update_input_and_run(struct csinn_tensor **input_tensors, void *sess);
#define csinn_nbg(...) NULL

int input_size[] = {1 * 384, 1 * 384, 1 * 384};
const char model_name[] = "network";

static void print_tensor_info(struct csinn_tensor *t)
{
    printf("\n=== tensor info ===\n");
    printf("shape: ");
    for (int j = 0; j < t->dim_count; j++) {
        printf("%d ", t->dim[j]);
    }
    printf("\n");
    if (t->dtype == CSINN_DTYPE_UINT8) {
        printf("scale: %f\n", t->qinfo->scale);
        printf("zero point: %d\n", t->qinfo->zero_point);
    }
    printf("data pointer: %p\n", t->data);
}

static void init_input_tensor(struct csinn_tensor *tensor)
{
    tensor->dim_count = 2;
    tensor->dim[0] = 1;
    tensor->dim[1] = ONNX_BERT_SEQ_LEN;
}

#ifndef ONNX_BERT_BAREMETAL
/*
 * Postprocess function
 */
static void postprocess(void *sess, const char *filename_prefix)
{
    int output_num, input_num;
    struct csinn_tensor *input = csinn_alloc_tensor(NULL);
    struct csinn_tensor *output = csinn_alloc_tensor(NULL);

    input_num = csinn_get_input_number(sess);
    for (int i = 0; i < input_num; i++) {
        input->data = NULL;
        csinn_get_input(i, input, sess);
        print_tensor_info(input);
    }

    output_num = csinn_get_output_number(sess);
    for (int i = 0; i < output_num; i++) {
        output->data = NULL;
        csinn_get_output(i, output, sess);
        print_tensor_info(output);

        struct csinn_tensor *foutput = shl_ref_tensor_transform_f32(output);

        char filename[FILE_LENGTH] = {0};
        char shape[SHAPE_LENGHT] = {0};
        shape2string(output->dim, output->dim_count, shape, SHAPE_LENGHT);
        snprintf(filename, FILE_LENGTH, "%s_output%u_%s.txt", filename_prefix, i, shape);
        int output_size = csinn_tensor_size(foutput);
        save_data_to_file(filename, (float *)foutput->data, output_size);

        shl_ref_tensor_transform_free_f32(foutput);
        if (!output->is_const) {
            shl_mem_free(output->data);
        }
    }
    csinn_free_tensor(input);
    csinn_free_tensor(output);
}

static void *create_graph(char *params_path)
{
    char *params = get_binary_from_file(params_path, NULL);
    if (params == NULL) {
        return NULL;
    }

    char *suffix = params_path + (strlen(params_path) - 7);
    if (strcmp(suffix, ".params") == 0) {
        return csinn_(params);
    }

    suffix = params_path + (strlen(params_path) - 3);
    if (strcmp(suffix, ".bm") == 0) {
        struct shl_bm_sections *section = (struct shl_bm_sections *)(params + 4128);
        if (section->graph_offset) {
            return csinn_import_binary_model(params);
        } else {
            return csinn_(params + section->params_offset * 4096);
        }
    }

    return NULL;
}

static int run_host(int argc, char **argv)
{
    char **data_path = NULL;
    int input_num = ONNX_BERT_INPUT_NUM;
    int input_group_num = 1;

    struct cmdline_options *option = cmdline_parser(argc, argv);
    if (option == NULL) {
        return -1;
    }

    int cmd_input_index = option->rest_line_index + 1;
    if (get_file_type(argv[cmd_input_index]) == FILE_TXT) {
        data_path = read_string_from_file(argv[cmd_input_index], &input_group_num);
        input_group_num /= input_num;
    } else {
        data_path = argv + cmd_input_index;
        input_group_num = (argc - cmd_input_index) / input_num;
    }

    void *sess = create_graph(argv[option->rest_line_index]);
    struct csinn_tensor *input_tensors[ONNX_BERT_INPUT_NUM];
    for (int i = 0; i < input_num; i++) {
        input_tensors[i] = csinn_alloc_tensor(NULL);
        init_input_tensor(input_tensors[i]);
    }

    float *inputf[ONNX_BERT_INPUT_NUM];
    char filename_prefix[FILE_PREFIX_LENGTH] = {0};
    uint64_t start_time, end_time;
    for (int i = 0; i < input_group_num; i++) {
        for (int j = 0; j < input_num; j++) {
            if (get_file_type(data_path[i * input_num + j]) != FILE_BIN) {
                printf("Please input binary files, since you compiled the model without preprocess.\n");
                return -1;
            }
            inputf[j] = (float *)get_binary_from_file(data_path[i * input_num + j], NULL);
            input_tensors[j]->data = shl_ref_f32_to_input_dtype(j, inputf[j], sess);
        }
        float time_all = 0.0f;
        for (int loop = 0; loop < option->loop_time; loop++) {
            start_time = shl_get_timespec();
            csinn_update_input_and_run(input_tensors, sess);
            end_time = shl_get_timespec();
            if (loop != 0) {
                time_all += ((float)(end_time - start_time)) / 1000000;
            }
            printf("Run graph execution time: %.5fms, FPS=%.5f\n",
                   ((float)(end_time - start_time)) / 1000000,
                   1000000000.0 / ((float)(end_time - start_time)));

            snprintf(filename_prefix, FILE_PREFIX_LENGTH, "%s", basename(data_path[i * input_num]));
            postprocess(sess, filename_prefix);
        }
        if (option->loop_time > 1) {
            printf("The number of run: %d\n", option->loop_time);
            printf("Run graph average execution time: %.5fms, FPS=%.5f\n",
                   time_all / (option->loop_time - 1), 1000.0 * (option->loop_time - 1) / time_all);
        }
        for (int j = 0; j < input_num; j++) {
            free(inputf[j]);
            shl_mem_free(input_tensors[j]->data);
        }
    }

    for (int j = 0; j < input_num; j++) {
        csinn_free_tensor(input_tensors[j]);
    }

    free(option);
    csinn_session_deinit(sess);
    csinn_free_session(sess);

    return 0;
}
#else
static size_t embedded_size(const unsigned char *start, const unsigned char *end)
{
    return (size_t)(end - start);
}

static const float *embedded_input_data(int index, size_t *count)
{
    const unsigned char *start = NULL;
    const unsigned char *end = NULL;

    switch (index) {
        case 0:
            start = _binary_input_ids_bin_start;
            end = _binary_input_ids_bin_end;
            break;
        case 1:
            start = _binary_input_mask_bin_start;
            end = _binary_input_mask_bin_end;
            break;
        case 2:
            start = _binary_segment_ids_bin_start;
            end = _binary_segment_ids_bin_end;
            break;
        default:
            return NULL;
    }

    *count = embedded_size(start, end) / sizeof(float);
    return (const float *)start;
}

static const float *embedded_gold_output(int index, size_t *count)
{
    const unsigned char *start = NULL;
    const unsigned char *end = NULL;

    switch (index) {
        case 0:
            start = _binary_gold_output0_bin_start;
            end = _binary_gold_output0_bin_end;
            break;
        case 1:
            start = _binary_gold_output1_bin_start;
            end = _binary_gold_output1_bin_end;
            break;
        default:
            return NULL;
    }

    *count = embedded_size(start, end) / sizeof(float);
    return (const float *)start;
}

struct compare_result {
    unsigned long mismatch_index;
    unsigned long mismatch_count;
    float max_abs_diff;
    float actual_at_first_mismatch;
    float expected_at_first_mismatch;
    int has_mismatch;
};

static struct compare_result compare_output(const float *actual, const float *expected,
                                            unsigned long count, float tolerance)
{
    struct compare_result result = {0};

    for (unsigned long i = 0; i < count; i++) {
        float diff = actual[i] - expected[i];
        if (diff < 0.0f) {
            diff = -diff;
        }
        if (diff > result.max_abs_diff) {
            result.max_abs_diff = diff;
        }
        if (diff > tolerance) {
            if (!result.has_mismatch) {
                result.has_mismatch = 1;
                result.mismatch_index = i;
                result.actual_at_first_mismatch = actual[i];
                result.expected_at_first_mismatch = expected[i];
            }
            result.mismatch_count++;
        }
    }

    return result;
}

static int validate_outputs(void *sess, float tolerance)
{
    int failures = 0;
    struct csinn_tensor *output = csinn_alloc_tensor(NULL);

    for (int i = 0; i < ONNX_BERT_OUTPUT_NUM; i++) {
        size_t expected_count = 0;
        const float *expected = embedded_gold_output(i, &expected_count);
        output->data = NULL;
        csinn_get_output(i, output, sess);

        struct csinn_tensor *foutput = shl_ref_tensor_transform_f32(output);
        unsigned long actual_count = (unsigned long)csinn_tensor_size(foutput);
        if (expected == NULL || actual_count != (unsigned long)expected_count) {
            printf("output_%d size mismatch: actual=%lu expected=%lu\n", i, actual_count,
                   (unsigned long)expected_count);
            failures++;
        } else {
            struct compare_result result =
                compare_output((const float *)foutput->data, expected, actual_count, tolerance);
            printf("output_%d: count=%lu max_abs_diff=%f mismatches=%lu tolerance=%f\n", i,
                   actual_count, result.max_abs_diff, result.mismatch_count, tolerance);
            if (result.has_mismatch) {
                printf("output_%d first mismatch at %lu: actual=%f expected=%f\n", i,
                       result.mismatch_index, result.actual_at_first_mismatch,
                       result.expected_at_first_mismatch);
                failures++;
            }
        }

        shl_ref_tensor_transform_free_f32(foutput);
        if (!output->is_const && output->data != NULL) {
            shl_mem_free(output->data);
        }
    }

    csinn_free_tensor(output);
    return failures;
}

static int run_baremetal(void)
{
    struct csinn_tensor *input_tensors[ONNX_BERT_INPUT_NUM] = {NULL};
    const unsigned long expected_input_count = ONNX_BERT_SEQ_LEN;
    int failures = 0;

    printf("onnx_bert bare-metal boot\n");
    if (embedded_size(_binary_model_params_bin_start, _binary_model_params_bin_end) == 0) {
        printf("embedded model params are empty\n");
        return -1;
    }

    printf("creating session\n");
    onnx_bert_tvmgen_register();
    void *sess = csinn_((char *)_binary_model_params_bin_start);
    printf("session ready\n");

    for (int i = 0; i < ONNX_BERT_INPUT_NUM; i++) {
        size_t count = 0;
        const float *inputf = embedded_input_data(i, &count);
        if (inputf == NULL || count != expected_input_count) {
            printf("input_%d size mismatch: actual=%lu expected=%lu\n", i, (unsigned long)count,
                   expected_input_count);
            failures = 1;
            break;
        }
        input_tensors[i] = csinn_alloc_tensor(NULL);
        init_input_tensor(input_tensors[i]);
        input_tensors[i]->data = shl_ref_f32_to_input_dtype(i, (float *)inputf, sess);
        printf("input_%d ready\n", i);
    }

    if (!failures) {
        printf("running inference\n");
        csinn_update_input_and_run(input_tensors, sess);
        printf("inference complete, validating outputs\n");
        failures = validate_outputs(sess, ONNX_BERT_OUTPUT_TOLERANCE);
    }

    for (int i = 0; i < ONNX_BERT_INPUT_NUM; i++) {
        if (input_tensors[i] != NULL) {
            if (input_tensors[i]->data != NULL) {
                shl_mem_free(input_tensors[i]->data);
            }
            csinn_free_tensor(input_tensors[i]);
        }
    }

    csinn_session_deinit(sess);
    csinn_free_session(sess);

    if (failures == 0) {
        printf("onnx_bert bare-metal validation passed\n");
        return 0;
    }

    printf("onnx_bert bare-metal validation failed with %d output issue(s)\n", failures);
    return 1;
}
#endif

int main(int argc, char **argv)
{
#ifdef ONNX_BERT_BAREMETAL
    (void)argc;
    (void)argv;
    return run_baremetal();
#else
    return run_host(argc, argv);
#endif
}
