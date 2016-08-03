// This macro stitches together tiled scans


//List of paths to datasets
fileList = newArray(
	"D:\\username\\diectory\\subdirectory\\filename0",
	"D:\\username\\diectory\\subdirectory\\filename1",
	"D:\\username\\diectory\\subdirectory\\filename2",
	"D:\\username\\diectory\\subdirectory\\filename3");
	
// Image height minus overlap (in pixels)
nStack = 280.0000

open(fileList[0]+"_Processed.tif");
rename("SecondImage");

for (i=1; i<fileList.length;i++)
{
	open(fileList[i]+"_Processed.tif");
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
saveAs("Tiff", fileList[0]+"_Stitched.tif");
