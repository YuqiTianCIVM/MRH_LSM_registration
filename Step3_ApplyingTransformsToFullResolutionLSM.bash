slicer=/k/CIVM_Apps/Slicer/4.11.20200930/Slicer.exe;#your slicer path
#Please change the paths in Line 10 -- 15

py_script=./Step2_Apply_transform_function.py;#your step2 path
project_code=19.gaj.23;
specimen_id=190108-1_1;

# set to 1 if you want slicer to stay open on failure
debug=false;
work_dir=/r/${project_code}/${specimen_id}/Non-Aligned-Data/${specimen_id}_NeuN_registration-work;#where you save the transforms in Step 1
in_file=/r/${project_code}/${specimen_id}/Non-Aligned-Data/reg/${resolution}/${specimen_id}_NeuN.nhdr;#full resolution LSM data to be registered
out_dir=/r/${project_code}/${specimen_id}/Non-Aligned-Data/${specimen_id}_NeuN_registration-results;#output directory
out_file=$out_dir/${specimen_id}_NeuN_registered_to_dwi.nhdr; #output file path
init_xform=$work_dir/Transform.mat; #the initialization transform

# mkdir if not already a dir
[ ! -d $out_dir ] && mkdir $out_dir;

if ${debug}; then 
	echo debug mode;
	echo running command $slicer --no-splash --python-script $py_script -p $work_dir -i $in_file -o $out_file -s $init_xform;
	$slicer --no-splash --python-script $py_script -p $work_dir -i $in_file -o $out_file -s $init_xform;
else
	echo running command $slicer --no-splash --exit-after-startup --no-main-window --python-script $py_script -p $work_dir -i $in_file -o $out_file -s $init_xform;
	$slicer --no-splash --exit-after-startup --no-main-window --python-script $py_script -p $work_dir -i $in_file -o $out_file -s $init_xform;
fi;
