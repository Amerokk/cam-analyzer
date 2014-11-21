




////////////////////////////////////////////////////////////////////////////////////////////
// Name          : 
// Creator       : Jalil Zerdani, master student @ Medicine,UNIL
// Purpose       : create a "doughnut" to isolate the Region of Interest (ROI) in a CAM assay
//                 with a membrane in it
// Creation date : 27.08.14
// Mod date      :
// Reason        :
////////////////////////////////////////////////////////////////////////////////////////////
//TODO: Name windows name
//TODO: User interface: confirm steps
//TODO: Mettre messages logs à chaque étape

////////////////////////////////////////

print("Running");


run("Action Bar","/plugins/ActionBar/Shared Bars/CAM_Analyzer.ijm");
exit();

/*
savingPath=path+File.separator+"savedFiles_"+method+"_a="+aNb+"_b="+bNb+"var="+variNb+File.separator;
		File.makeDirectory(savingPath);*/

<beanshell>
import ij.IJ;
import ij.ImagePlus;
import ij.plugin.Duplicator;
import ij.plugin.ImageCalculator;
import ij.WindowManager;
import ij.util.ArrayUtil;
import features.TubenessProcessor;
import ij.gui.WaitForUserDialog;
import ij.plugin.frame.RoiManager;
import ij.plugin.filter.GaussianBlur;
import ij.plugin.frame.ThresholdAdjuster;
import ij.io.DirectoryChooser;
import java.io.File;



// Global Constants
isDebug = false;
sigma = 15; // sigma for gaussian blur in preprocessing
// Diameters of Tubeness
smallDiam = 20;
largeDiam = 30;

// Show Debug
////////////////////////////////////////////
void showDb(ImagePlus imp) 
////////////////////////////////////////////
{
	if (isDebug) 
		imp.show();
}

// Log Debug
////////////////////////////////////////////
void logDb(ImagePlus imp) 
////////////////////////////////////////////
{
	if (isDebug) 
		imp.show();
}


<line>
<button> 1 line 1
label=Preprocess
icon=new_action_bar/image1_1.png
arg=<bsh>
//showMessage("You pressed button 1 line 1");
// Dialog to prompt user for Directory
DirectoryChooser dc = new DirectoryChooser("Select where are your images to preprocess");



</bsh>
<button> 2 line 1
label=button_2_1
icon=new_action_bar/image2_1.png
arg=<macro>
showMessage("You pressed button 2 line 1");
</macro>
<button> 3 line 1
label=button_3_1
icon=new_action_bar/image3_1.png
arg=<macro>
showMessage("You pressed button 3 line 1");
</macro>
<button> 4 line 1
label=button_4_1
icon=new_action_bar/image4_1.png
arg=<macro>
showMessage("You pressed button 4 line 1");
</macro>
<button> 5 line 1
label=button_5_1
icon=new_action_bar/image5_1.png
arg=<macro>
showMessage("You pressed button 5 line 1");
</macro>
<button> 6 line 1
label=button_6_1
icon=new_action_bar/image6_1.png
arg=<macro>
showMessage("You pressed button 6 line 1");
</macro>
<button> 7 line 1
label=button_7_1
icon=new_action_bar/image7_1.png
arg=<macro>
showMessage("You pressed button 7 line 1");
</macro>
<button> 8 line 1
label=button_8_1
icon=new_action_bar/image8_1.png
arg=<macro>
showMessage("You pressed button 8 line 1");
</macro>
</line>
<line>
<button> 1 line 2
label=button_1_2
icon=new_action_bar/image1_2.png
arg=<macro>
showMessage("You pressed button 1 line 2");
</macro>
<button> 2 line 2
label=button_2_2
icon=new_action_bar/image2_2.png
arg=<macro>
showMessage("You pressed button 2 line 2");
</macro>
<button> 3 line 2
label=button_3_2
icon=new_action_bar/image3_2.png
arg=<macro>
showMessage("You pressed button 3 line 2");
</macro>
<button> 4 line 2
label=button_4_2
icon=new_action_bar/image4_2.png
arg=<macro>
showMessage("You pressed button 4 line 2");
</macro>
<button> 5 line 2
label=button_5_2
icon=new_action_bar/image5_2.png
arg=<macro>
showMessage("You pressed button 5 line 2");
</macro>
<button> 6 line 2
label=button_6_2
icon=new_action_bar/image6_2.png
arg=<macro>
showMessage("You pressed button 6 line 2");
</macro>
<button> 7 line 2
label=button_7_2
icon=new_action_bar/image7_2.png
arg=<macro>
showMessage("You pressed button 7 line 2");
</macro>
<button> 8 line 2
label=button_8_2
icon=new_action_bar/image8_2.png
arg=<macro>
showMessage("You pressed button 8 line 2");
</macro>
</line>
// end of file





// Normalization of image between 0 and 1 (for thresholding)
////////////////////////////////////////////
ImagePlus normalizeImp(ImagePlus imp)
////////////////////////////////////////////
{
	//new WaitForUserDialog("Measure a square of the Oring").show();
	//TODO: Réfléchir si on peut améliorer par exemple avec Filtre passe-haut
	stats = imp.getStatistics();
	max = stats.max;
	min = stats.min;
	factor = max-min;
	
	IJ.run(imp, "Subtract...", "value=" + min);
	IJ.run(imp, "Divide...", "value=" + factor);
	
	return imp;
}

////////////////////////////////////////////
ImagePlus preprocessImp(ImagePlus imp, double sigma, String filename) 
////////////////////////////////////////////
{
	IJ.log("Background removal on " + filename);

	
	
	// Background removal (pre-processing) 1px gaussian filter
	IJ.run(imp, "Gaussian Blur...", "sigma=1");
	
	ImagePlus impBgr = new Duplicator().run(imp);
	ImageCalculator ic = new ImageCalculator();

	IJ.run(impBgr, "Gaussian Blur...", "sigma=15");
	impBgrRemoved = ic.run("Divide create 32-bit", imp, impBgr);

	impPreprocessed = normalizeImp(impBgrRemoved);

	IJ.log("Background removed on " + imp.getTitle());
	
	return impPreprocessed;
}

////////////////////////////////////////////
ImagePlus tubenessImp (ImagePlus impOrig, double sigma, String fielename) 
{
////////////////////////////////////////////

	ImagePlus imp = new Duplicator().run(impOrig);
	
	IJ.log("Tubeness processing of " + filename);
	Prefs.blackBackground = true;
	imp.hide();
	IJ.run(imp, "Invert", "");

	// Takes the tubeness
	TubenessProcessor tp = new TubenessProcessor(sigma, true);
	ImagePlus impTube = tp.generateImage(imp);
	
	impTube.setTitle("Tubeness of "+ imp.getTitle());

	IJ.log("Tubeness of " + filename + " processed");

	return impTube;
}

/////////////////////////////////////////////////
///////////////////////// MAIN //////////////////
/////////////////////////////////////////////////
// Install common functions
//IJ.call("BIOP_LibInstaller.installLibrary", "BIOP"+File.separator+"BIOPLib.ijm");


/*



chosenDirPath = dc.getDirectory();

origDirPath = chosenDirPath + "orig/";
preprocDirPath = chosenDirPath + "preprocess/";

File mainDir = new File(origDirPath);
File preprocDir = new java.io.File(preprocDirPath);


File[] listOfFiles = mainDir.listFiles();*/

/*
//TODO: Créer le dossier preprocess avec du code

run("MakeDirectory ", DESTDIR);
test = preprocDir.mkDir();
 File.makeDirectory(preprocessDir);

IJ.log("***");
IJ.log(origDirPath);
IJ.log(preprocDirPath);
*/

//IJ.log(listOfFiles);



/*

for (int i = 0; i < listOfFiles.length; i++) 
{
	// on évite .DS_store et autres fichiers
	if (listOfFiles[i].getName().endsWith(".tif")) 
	{
		ImageCalculator ic = new ImageCalculator();
	
		filename = listOfFiles[i].getName();
		
		origImagePath = origDirPath + filename;
		preprocImagePath = preprocDirPath + filename;
		
		impOrig = IJ.openImage(origImagePath);
		IJ.log("Opening " + filename);
		
		impPreproc = preprocessImp(impOrig, sigma, filename);
		
		// Tubeness
		impTubeLarge = tubenessImp(impPreproc, largeDiam, filename);
		impTubeSmall = tubenessImp(impPreproc, smallDiam, filename);

		ImagePlus impTubeTotal = ic.run("Add create 32-bit", impTubeLarge, impTubeSmall);

		IJ.saveAs(impTubeTotal, "Tiff", preprocImagePath);
		IJ.log(filename + " saved");
		IJ.log("");


	}
} */
