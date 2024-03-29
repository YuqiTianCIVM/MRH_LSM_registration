Thank you for using our method. Please cite our paper (Johnson, Tian 2023) from PNAS and (Tian, Cook, Johnson 2022) from Frontiers in Neuroscience.
 
The transforms are generated from Step 1. Before running Step 1, please downsample your data to 15um or 45um depending on your needs.
Step 1 with 15um data usually takes ~10 hours and has better performance(recommended)

Then please initialize based on the paper method section. If needed, please follow the example shown in Figure S5 B and D.
Save the transform in the working directory.

To run the Step 1, make sure the paths in the file are set up correctly. The annotations will direct you to the paths.

Input
$perl Step1_path.pl

in the bash. 

After transforms are generated, please go to Step 3 file. Make sure the names of files and paths are consistent. 
The Step 3 usually takes 2 hours on a computing resource described in the paper. Please make sure your computer has large memory and page faulting.

Input 
$bash Step3_path.bash
in the bash. 

Plus: Authors suggest implementing the workflow on windows/unix system. If you have any questions, please contact the corresponding author. 
