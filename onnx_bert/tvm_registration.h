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

#ifndef ONNX_BERT_TVM_REGISTRATION_H_
#define ONNX_BERT_TVM_REGISTRATION_H_

#include "shl_tvmgen.h"

struct onnx_bert_tvmgen_registry {
    const struct shl_tvmgen_name_func *map;
    int size;
};

/*
 * External TVM-generated sources should provide a strong definition of
 * onnx_bert_tvmgen_registry() and use operator names that exactly match the
 * params->name strings emitted by onnx_bert/model.c.
 */
const struct onnx_bert_tvmgen_registry *onnx_bert_tvmgen_registry(void);
void onnx_bert_tvmgen_register(void);

#endif  // ONNX_BERT_TVM_REGISTRATION_H_
