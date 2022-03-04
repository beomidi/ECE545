/******************************************************************************
 * Copyright (C) 2010 - 2021 Xilinx, Inc.  All rights reserved.
 * SPDX-License-Identifier: MIT
 ******************************************************************************/

/*****************************************************************************/
/**
 *
 * @file		xuartps_hello_world_example.c
 *
 * This file contains a design example using the XUartPs driver in polled mode
 *
 * The example uses the default setting in the XUartPs driver:
 *	. baud rate 9600
 *	. 8 bit data
 *	. 1 stop bit
 *	. no parity
 *
 * @note
 * This example requires an external SchmartModule connected to the pins for
 * the device to display the 'Hello World' message onto a hyper-terminal.
 *
 * MODIFICATION HISTORY:
 * <pre>
 * Ver   Who    Date     Changes
 * ----- ------ -------- -------------------------------------------------
 * 1.00a drg/jz 01/13/10 First Release
 * 1.04a  hk    22/04/13 Changed the baud rate in the example to 115200.
 *				Fix for CR#707879
 * 3.4    ms    01/23/17 Added xil_printf statement in main function to
 *                       ensure that "Successfully ran" and "Failed" strings
 *                       are available in all examples. This is a fix for
 *                       CR-965028.
 *
 * </pre>
 ******************************************************************************/

/***************************** Include Files *********************************/

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xgpio.h"
#include "xuartps.h"
#include "xil_io.h"

/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define UART_DEVICE_ID                  XPAR_XUARTPS_0_DEVICE_ID

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

int UartPsHelloWorldExample(u16 DeviceId);

/************************** Variable Definitions *****************************/

XUartPs Uart_Ps; /* The instance of the UART Driver */

/*****************************************************************************/
/**
 *
 * Main function to call the Hello World example.
 *
 *
 * @return
 *		- XST_FAILURE if the Test Failed .
 *		- A non-negative number indicating the number of characters
 *		  sent.
 *
 * @note		None
 *
 ******************************************************************************/
#define BUFFER_SIZE 4

static u8 SendBuffer[BUFFER_SIZE]; /* Buffer for Transmitting Data */
static u8 RecvBuffer[BUFFER_SIZE]; /* Buffer for Receiving Data */

XGpio Gpio0; /* The Instance of the GPIO Driver */
XGpio Gpio1; /* The Instance of the GPIO Driver */

int main() {
	init_platform();
	int Status;
	/* Initialize the GPIO0 driver */
	Status = XGpio_Initialize(&Gpio0, XPAR_GPIO_0_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio0 Initialization Failed\r\n");
		return XST_FAILURE;
	}

	/* Initialize the GPIO1 driver */
	Status = XGpio_Initialize(&Gpio1, XPAR_GPIO_1_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio1 Initialization Failed\r\n");
		return XST_FAILURE;
	}

	int SentCount = 0;
	XUartPs_Config *Config;
	unsigned int ReceivedCount;

	/*
	 * Initialize the UART driver so that it's ready to use
	 * Look up the configuration in the config table and then initialize it.
	 */
	Config = XUartPs_LookupConfig(XPAR_XUARTPS_0_DEVICE_ID);
	if (NULL == Config) {
		return XST_FAILURE;
	}

	Status = XUartPs_CfgInitialize(&Uart_Ps, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XUartPs_SetBaudRate(&Uart_Ps, 115200);

	/* Set the direction for all signals as output */
	XGpio_SetDataDirection(&Gpio0, 1, 0);
	XGpio_SetDataDirection(&Gpio0, 2, 0);

	/* Set the direction for all signals as input */
	XGpio_SetDataDirection(&Gpio1, 1, 0xffffffff);
	XGpio_SetDataDirection(&Gpio1, 2, 0xffffffff);

	/* input shares */
	u8 x[4];
	u8 y[4];

	while (1) {
		/* Block receiving the buffer. */
		ReceivedCount = 0;
		while (ReceivedCount < BUFFER_SIZE) {
			x[ReceivedCount] = XUartPs_RecvByte(Config->BaseAddress);
			ReceivedCount++;
		}

		/* Block receiving the buffer. */
		ReceivedCount = 0;
		while (ReceivedCount < BUFFER_SIZE) {
			y[ReceivedCount] = XUartPs_RecvByte(Config->BaseAddress);
			ReceivedCount++;
		}

		/*Concatenation of shares to fit in 32 STD_LOGIC_VECTOR */
		u32 x_temp = (x[3] << 24) | (x[2] << 16) | (x[1] << 8) | x[0];
		u32 y_temp = (y[3] << 24) | (y[2] << 16) | (y[1] << 8) | y[0];

		/* input shares */

		/*Sending shares to GPIO for processing*/
		XGpio_DiscreteWrite(&Gpio0, 1, x_temp);
		XGpio_DiscreteWrite(&Gpio0, 2, y_temp);


		/*Collecting computed shares from GPIO*/
		u32 a2b = XGpio_DiscreteRead(&Gpio1, 1);
		u32 b2a = XGpio_DiscreteRead(&Gpio1, 2);

		/*Sending A2B and b2A results to the host*/
		xil_printf("%08x\n", a2b);
		xil_printf("%08x\n", b2a);
	}

	return 0;
}

