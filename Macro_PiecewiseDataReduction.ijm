// Macro_DataReduction
// Harold Barnard, 20160722 12:30pm

// Macro for data reduction:
// This macro converts directories of 32 bit reconstructions to 8 bit images stack and scales by a factor of 2
// This operation is performed in N subvolumes to reduce memory requirements

pathOut = "G:\\S405_Catalyst_Analysis\\S405_recons_8Bit\\"

// List of file names
// Do not include _0000 or .h5 extension in file name
fileNameList = newArray(
	"20151010_210103_S405_10X_sample3_01",
	"20151010_213032_S405_10X_sample3_02",
	"20151010_220245_S405_10X_sample3_03",
	"20151010_223342_S405_10X_sample3_04",
	"20151010_230803_S405_10X_sample3_05",
	"20151010_233919_S405_10X_sample3_06",
	"20151011_001205_S405_10X_sample3_07");


// List of paths to files
// MAKE SURE Double backslahes are used in paths (for windows) and that the file paths ends with \\
pathList = newArray(
	"G:\\S405_Catalyst_Analysis\\S405_recons_32Bit\\recon_20151010_210103_S405_10x_ sample3_01\\",
	"G:\\S405_Catalyst_Analysis\\S405_recons_32Bit\\recon_20151010_213032_S405_10x_ sample3_02\\",
	"G:\\S405_Catalyst_Analysis\\S405_recons_32Bit\\recon_20151010_220245_S405_10x_ sample3_03\\",
	"G:\\S405_Catalyst_Analysis\\S405_recons_32Bit\\recon_20151010_223342_S405_10x_ sample3_04\\",
	"G:\\S405_Catalyst_Analysis\\S405_recons_32Bit\\recon_20151010_230803_S405_10x_ sample3_05\\",
	"G:\\S405_Catalyst_Analysis\\S405_recons_32Bit\\recon_20151010_233919_S405_10x_ sample3_06\\",
	"G:\\S405_Catalyst_Analysis\\S405_recons_32Bit\\recon_20151011_001205_S405_10x_ sample3_07\\");


Nimage = 2160; // Number of images in stack
NsubVolume = 10; // Data reduction performed in smaller subvolumes to reduce memory requirements, increase NsubVolumes if memory fills up

// Make sure Image size is correct (this changes if you select a smaller ROI or different camera)
imWidth = 2650; // Image Width
imHeight = 2650; // Image Height

// User brightness and contrast window to figure out optimal pixel scaling for contrast
pixelMin = -2.0; 
pixelMax = 5.0;

// macro scales by a factor of 2, change to false if you do not want to scale
scaleXY = true; 
scaleZ = false;
//==================================================================================================
// NO CHANGES NECESSARY BELOW THIS LINE


dsub = floor(Nimage/NsubVolume);

Nfile = lengthOf(fileNameList); 

for (i=0;i<Nfile;i++)
//for (i=0;i<1;i++)
{
	partList = " ";
	for (j=0;j<NsubVolume;j++)
	{
		start = j*dsub+1; print(start);
		run("Image Sequence...","open=["+pathList[i]+fileNameList[i]+"_00000.tif] starting="+start+" number="+dsub+" sort");
		rename("32Bit");
		//run("Brightness/Contrast...");
		setMinAndMax(pixelMin, pixelMax);
		run("8-bit","stack");
		if (scaleXY == true){
			run("Scale...", "x=.5 y=.5 z= 1.0 width="+imWidth/2+" height="+imHeight/2+" depth="+dsub+" interpolation=Bilinear average process create");
		} else {
			run("Duplicate...", "duplicate");
		}
		rename("part "+j);
		partList = partList+" image"+j+1+"=[part "+j+"]";
		selectWindow("32Bit");
		close();
	}
	run("Concatenate...", "  title=[8Bit Stack Complete]"+partList );
	//run("Concatenate...", "all_open title=[Concatenated Stacks]");
	if (scaleZ==true){
		run("Scale...", "x=1 y=1 z=0.5 width="+imWidth/2+" height="+imHeight/2+" depth="+floor(Nimage/2)+" interpolation=Bilinear average process create");
	} else {
		run("Duplicate...", "duplicate");
	}
	saveAs("Tiff", pathOut + fileNameList[i] + "_8bit.tif");
	close();
	close();
} 
