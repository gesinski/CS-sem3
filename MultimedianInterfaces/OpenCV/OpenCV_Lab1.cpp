#include <stdio.h> // stderr, stdin, stdout
#include <iostream> // I/O streaming 
using namespace std; // standard name space

// OpenCV
#include <opencv2/opencv.hpp> // OpenCV header file
using namespace cv; // OpenCV name space

// Place global declarations below
// ....
Mat srcImage; // Source image
Mat greyImage;

const int maxValue = 255;

void CreateWindow(const char* name, int x, int y) {
	namedWindow(name, WINDOW_AUTOSIZE);
	moveWindow(name, x, y);
}

void ShowImage(Mat img, const char* name, int x, int y) {
	CreateWindow(name, x, y);
	imshow(name, img);
}

void Brightness(Mat src, Mat dst, int val) {
	for (int col = 0; col < src.cols; col++) {
		for (int row = 0; row < src.rows; row++) {
			Vec3b pixelColor = src.at<Vec3b>(col, row);

			for (int i = 0; i < 3; i++) {
				if (pixelColor[i]+val < 255) {
					pixelColor[i] += val;
				}
				else {
					pixelColor[i] = 254;
				}
			}
			dst.at<Vec3b>(col, row) = pixelColor;
		}
	}
}

void Threshold(int pos, void* userdata) {
	Mat* img = (Mat*)userdata;
	threshold(greyImage, *img, pos, maxValue, THRESH_BINARY);
	imshow("Binarization", *img);
}

void BrightnessHSL(Mat src, Mat dst, int B) {

}

int main()
{ 
	srcImage = imread( "Samples/Fish.jpg" ); // reading source file
	if ( !srcImage.data )
	{ // Reading error
		cout << "Error! Cannot read source file. Press any key."; // could't read the source file
		waitKey(); // No params - wait for a key press
		return( -1 ); // exit with error code
	} 
	else {
		ShowImage(srcImage, "Nazwisko Imie", 0, 0);

		cvtColor(srcImage, greyImage, COLOR_BGR2GRAY);
		ShowImage(greyImage, "Grey image", 300, 0);
		imwrite( "Samples/Grey image.jpg", greyImage);

		Mat resizedImage(160, 160, srcImage.type());
		resize(srcImage, resizedImage, resizedImage.size());
		ShowImage(resizedImage, "Minimized", 600, 0);

		Mat blurredImage;
		GaussianBlur(srcImage, blurredImage, Size(9, 9), 2.0f);
		ShowImage(blurredImage, "Gaussian filter", 900, 0);

		Mat CannyImage;
		Canny(srcImage, CannyImage, 59.0, 56.0);
		ShowImage(CannyImage, "Canny edge detector", 1200, 0);

		Mat LaplacianImage;
		Laplacian(greyImage, LaplacianImage, CV_16S, 3);
		Mat scaledLaplacianImage;
		convertScaleAbs(LaplacianImage, scaledLaplacianImage);
		ShowImage(scaledLaplacianImage, "Laplacian filter", 1500, 0);

		//2
		Mat brightImage;
		srcImage.copyTo(brightImage);
		Brightness(brightImage, brightImage, 110);
		ShowImage(brightImage, "Bright Image", 0, 300);

		//3
		int threshold_value = 110;
		Mat binarizedImage;
		CreateWindow("Binarization", 300, 600);
		createTrackbar("Threshold value", "Binarization", &threshold_value, maxValue, Threshold, &binarizedImage);

		//4
		Mat imageHSL, brightImageHSL;
		cvtColor(srcImage, imageHSL, COLOR_BGR2HLS);
		vector<Mat> channels;
		//split(&imageHSL, channels);

		waitKey();
	}
	return 0;
}
