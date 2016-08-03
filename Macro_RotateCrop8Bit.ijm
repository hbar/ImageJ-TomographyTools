
//List of paths to datasets
fileList = newArray(
	"D:\\username\\diectory\\subdirectory\\filename0",
	"D:\\username\\diectory\\subdirectory\\filename1",
	"D:\\username\\diectory\\subdirectory\\filename2",
	"D:\\username\\diectory\\subdirectory\\filename3");
	
// Rescale pixels for 8-bit conversion
MaxPixelValue = 1.3343
MinPixelValue = -0.8382

// Rotate Image
RotateImage = true;
Angle = 0;

// Crop Region: 
CropImage = true;
x1 = 950; // x1,y1 upper left corner pixel
y1 = 120;
x2 = 524; // x2,y2 lower left corner pixel
y2 = 2600;

for (i=0; i<fileList.length;i++)
{
	open(fileList[i]+".tif");
	if (RotateImage== true){
		run("Rotate... ", "angle="+Angle+" grid=1 interpolation=Bilinear enlarge stack");
	}
	
	if (CropImage==true){
		makeRectangle(x1, y1, x2, y2);
		run("Crop");
	}
	//run("Brightness/Contrast...");
	setMinAndMax(MinPixeValue, MaxPixelValue);
	run("8-bit");
	
	saveAs("Tiff", fileList[i]+"_Processed.tif");
	run("Close");
};

