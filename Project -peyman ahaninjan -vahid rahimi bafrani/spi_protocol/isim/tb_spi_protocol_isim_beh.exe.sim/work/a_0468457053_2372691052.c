/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "E:/VHDL_Elmos/spi_protocol/tb_spi_protocol.vhd";
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_1657552908_1035706684(char *, char *, char *);
unsigned char ieee_p_1242562249_sub_1781507893_1035706684(char *, char *, char *, int );
char *ieee_p_1242562249_sub_1919365254_1035706684(char *, char *, char *, char *, int );
char *ieee_p_1242562249_sub_1919437128_1035706684(char *, char *, char *, char *, int );
unsigned char ieee_p_1242562249_sub_3140849233_1035706684(char *, char *, char *, int );


static void work_a_0468457053_2372691052_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;

LAB0:    t1 = (t0 + 4232U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(69, ng0);
    t2 = (t0 + 4880);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(70, ng0);
    t2 = (t0 + 3248U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 4040);
    xsi_process_wait(t2, t8);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(71, ng0);
    t2 = (t0 + 4880);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(72, ng0);
    t2 = (t0 + 3248U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 4040);
    xsi_process_wait(t2, t8);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_0468457053_2372691052_p_1(char *t0)
{
    char t10[16];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned char t8;
    unsigned char t9;
    unsigned int t11;
    unsigned int t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    int t18;
    int t19;
    unsigned int t20;

LAB0:    xsi_set_current_line(83, ng0);
    t1 = (t0 + 4944);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(84, ng0);
    t1 = (t0 + 7840);
    t3 = (t0 + 5008);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t1, 24U);
    xsi_driver_first_trans_fast(t3);
    xsi_set_current_line(85, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t8 = *((unsigned char *)t2);
    t9 = (t8 == (unsigned char)2);
    if (t9 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4800);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(86, ng0);
    t1 = (t0 + 2952U);
    t3 = *((char **)t1);
    t1 = (t0 + 7760U);
    t4 = ieee_p_1242562249_sub_1919365254_1035706684(IEEE_P_1242562249, t10, t3, t1, 1);
    t5 = (t10 + 12U);
    t11 = *((unsigned int *)t5);
    t12 = (1U * t11);
    t13 = (2U != t12);
    if (t13 == 1)
        goto LAB5;

LAB6:    t6 = (t0 + 5072);
    t7 = (t6 + 56U);
    t14 = *((char **)t7);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memcpy(t16, t4, 2U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(87, ng0);
    t1 = (t0 + 2952U);
    t2 = *((char **)t1);
    t1 = (t0 + 7760U);
    t8 = ieee_p_1242562249_sub_1781507893_1035706684(IEEE_P_1242562249, t2, t1, 3);
    if (t8 != 0)
        goto LAB7;

LAB9:
LAB8:    xsi_set_current_line(91, ng0);
    t1 = (t0 + 2792U);
    t2 = *((char **)t1);
    t1 = (t0 + 7744U);
    t8 = ieee_p_1242562249_sub_1781507893_1035706684(IEEE_P_1242562249, t2, t1, 0);
    if (t8 != 0)
        goto LAB12;

LAB14:
LAB13:    xsi_set_current_line(95, ng0);
    t1 = (t0 + 2792U);
    t2 = *((char **)t1);
    t1 = (t0 + 7744U);
    t8 = ieee_p_1242562249_sub_3140849233_1035706684(IEEE_P_1242562249, t2, t1, 7);
    if (t8 != 0)
        goto LAB15;

LAB17:
LAB16:    goto LAB3;

LAB5:    xsi_size_not_matching(2U, t12, 0);
    goto LAB6;

LAB7:    xsi_set_current_line(88, ng0);
    t3 = (t0 + 2792U);
    t4 = *((char **)t3);
    t3 = (t0 + 7744U);
    t5 = ieee_p_1242562249_sub_1919437128_1035706684(IEEE_P_1242562249, t10, t4, t3, 1);
    t6 = (t10 + 12U);
    t11 = *((unsigned int *)t6);
    t12 = (1U * t11);
    t9 = (5U != t12);
    if (t9 == 1)
        goto LAB10;

LAB11:    t7 = (t0 + 5136);
    t14 = (t7 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    memcpy(t17, t5, 5U);
    xsi_driver_first_trans_fast(t7);
    xsi_set_current_line(89, ng0);
    t1 = (t0 + 7864);
    t3 = (t0 + 5072);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t1, 2U);
    xsi_driver_first_trans_fast(t3);
    goto LAB8;

LAB10:    xsi_size_not_matching(5U, t12, 0);
    goto LAB11;

LAB12:    xsi_set_current_line(92, ng0);
    t3 = (t0 + 7866);
    t5 = (t0 + 5136);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t14 = (t7 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t3, 5U);
    xsi_driver_first_trans_fast(t5);
    xsi_set_current_line(93, ng0);
    t1 = (t0 + 5200);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    *((unsigned char *)t5) = (unsigned char)4;
    xsi_driver_first_trans_fast(t1);
    goto LAB13;

LAB15:    xsi_set_current_line(96, ng0);
    t3 = (t0 + 1512U);
    t4 = *((char **)t3);
    t3 = (t0 + 2792U);
    t5 = *((char **)t3);
    t3 = (t0 + 7744U);
    t18 = ieee_p_1242562249_sub_1657552908_1035706684(IEEE_P_1242562249, t5, t3);
    t19 = (t18 - 23);
    t11 = (t19 * -1);
    xsi_vhdl_check_range_of_index(23, 0, -1, t18);
    t12 = (1U * t11);
    t20 = (0 + t12);
    t6 = (t4 + t20);
    t9 = *((unsigned char *)t6);
    t7 = (t0 + 5200);
    t14 = (t7 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t9;
    xsi_driver_first_trans_fast(t7);
    goto LAB16;

}


extern void work_a_0468457053_2372691052_init()
{
	static char *pe[] = {(void *)work_a_0468457053_2372691052_p_0,(void *)work_a_0468457053_2372691052_p_1};
	xsi_register_didat("work_a_0468457053_2372691052", "isim/tb_spi_protocol_isim_beh.exe.sim/work/a_0468457053_2372691052.didat");
	xsi_register_executes(pe);
}
