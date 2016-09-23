// This macro stitches together tiled scans


// List of paths to reconstructed datasets (with file extension)
// if dataset is a directory with many tiff files, use name of first image

fileList = newArray(
	"D:\\username\\diectory\\subdirectory\\filename0.tiff",
	"D:\\username\\diectory\\subdirectory\\filename1.tiff",
	"D:\\username\\diectory\\subdirectory\\filename2.tiff",
	"D:\\username\\diectory\\subdirectory\\filename3.tiff");

// Number of images in each dataset minus overlap (in pixels)
nStack = 280.0000

// if the datasets are directories full of images, leave false
// change to true if datasets are single file tiff stacks 
singleFile = false;
if (singleFile==false){ open(fileList[0]); }
if (singleFile==true){ 	run("Image Sequence...", "open="+fileList[0]+" sort"); }
rename("SecondImage");

for (i=1; i<fileList.length;i++)
{
	if (singleFile==false) { 
		open(fileList[0]);
	}
	if (singleFile==true){
		run("Image Sequence...", "open="+fileList[i]+" sort");
	}
	
	rename("FirstImage");
	run("Pairwise stitching", "first_image=FirstImage second_image=SecondImage fusion_method=[Linear Blending] fused_image=FusedImage check_peaks=5 x=0.0000 y=0.0000 z=”+nStack+” registration_channel_image_1=[Average all channels] registration_channel_image_2=[Average all channels]");

	selectWindow("FirstImage");
	close();

	selectWindow("SecondImage");
	close();

	selectWindow("FusedImage");
	rename("SecondImage");
}
selectWindow("SecondImage");

// extract root file name to insert into output file name
fileName = fileList[0]; fileName = replace(fileName,".tiff"); fileName = replace(fileName,".tif");

// safe file
saveAs("Tiff",fileName+"_Stitched.tif");
