# NeiborhoodImageProcessing
In Neighborhood Processing, the new pixel value g(x, y) is calculated based on not only the original pixel at the same position f(x, y), but also with its neighbors, as well as a Kernel:
![Screenshot 2024-11-11 092402.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/bbb3762a-335e-492c-8c88-25255b9c1516/e09e6ac6-a613-4f1a-bc21-477204219027/Screenshot_2024-11-11_092402.png)

## Kernel
In image processing, a kernel, convolution matrix, or mask is a small matrix used for blurring, sharpening, embossing, edge detection, and more. This is accomplished by doing a convolution between the kernel and an image. Or more simply, when each pixel in the output image is a function of the nearby pixels (including itself) in the input image, the kernel is that function.
Box blur
(normalized)	
1
9
[
 
 
1
 
 
1
 
 
1
 
 
1
 
 
1
 
 
1
 
 
1
 
 
1
 
 
1
]
{\displaystyle {\frac {1}{9}}{\begin{bmatrix}\ \ 1&\ \ 1&\ \ 1\\\ \ 1&\ \ 1&\ \ 1\\\ \ 1&\ \ 1&\ \ 1\end{bmatrix}}}
### Convolution with a Kernel Animation
![2D_Convolution_Animation.gif](https://prod-files-secure.s3.us-west-2.amazonaws.com/bbb3762a-335e-492c-8c88-25255b9c1516/192a5d63-b897-49a8-ae35-eaa631a18149/2D_Convolution_Animation.gif)
## Line Buffer
A line buffer is a temporary storage area used in image processing to hold a row (or "line") of pixels. Line buffers are particularly useful in hardware and real-time image processing, especially when working with streaming data or images that need to be processed sequentially, line by line.
