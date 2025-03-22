# Spring Lab3: FIR Design
## Introduction
In this Lab, we need to implement finite impulse response.
    $$y[n] = \sum_{i=1}^{N} h[i]x[n-i]$$
We have three-part, $\texttt{tap\_RAM}$, $\texttt{data\_RAM}$ and $\texttt{fir}$. The $\texttt{testbench}$ communicates with the $\texttt{fir}$ by $\textbf{Advanced eXtensible Interface(AXI Lite and AXI Stream)}$. AXI Lite will be used to access $\texttt{tap\_RAM}$ and $\texttt{configuration register}$ in $\texttt{fir}$. AXI Stream will be used to access $\texttt{data\_RAM}$ and output the calculation result of $\texttt{fir}$ to the testbench.

The data path of my design is shown in the following figure, and FSM determines the control signal.

![](./images/fir_block.jpg)

## Report

## Error correction 
https://hackmd.io/@VYAZ71eHRa2w0l_K52GM0g/SJPAovHnkl