
int get_vtimer()
{
  volatile unsigned int   LoadCount;
  asm ("csrr %[LoadCount], time\n"
      :[LoadCount]"=r"(LoadCount)
      :
      :
      );
  //LoadCount = *TIMER_ADDR;
  return LoadCount;
}

void sim_end()
{
}
