# NeiborhoodImageProcessing
In Neighborhood Processing, the new pixel value g(x, y) is calculated based on not only the original pixel at the same position f(x, y), but also with its neighbors, as well as a Kernel:
![Screenshot 2024-11-11 092402](https://github.com/user-attachments/assets/5ff79ce5-737a-44e4-bc24-e3c737c0dcbf)


## Kernel
In image processing, a kernel, convolution matrix, or mask is a small matrix used for blurring, sharpening, embossing, edge detection, and more. This is accomplished by doing a convolution between the kernel and an image. Or more simply, when each pixel in the output image is a function of the nearby pixels (including itself) in the input image, the kernel is that function.
![image](https://github.com/user-attachments/assets/1459c238-089c-458e-a342-acc7b2479e68)

### Convolution with a Kernel Animation
![2D_Convolution_Animation](https://github.com/user-attachments/assets/11c03356-b8a5-40fd-9c33-73fb2843cb22)

## Line Buffer
A line buffer is a temporary storage area used in image processing to hold a row (or "line") of pixels. Line buffers are particularly useful in hardware and real-time image processing, especially when working with streaming data or images that need to be processed sequentially, line by line.
