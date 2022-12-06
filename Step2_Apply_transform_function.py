#this example code shows a function of applying transform generated in Step 1 in Slicer 
#you dont need to configure this file. 

import os
import sys
from optparse import OptionParser
import logging
def ApplyTransforms(args): 
    logging.error('Watch out!')   
        # add a sink to split/push log data wheverever i want 
    parser = OptionParser()
    parser.add_option("-p", "--transform_path", action="store", type="string", dest="transform_path", default='')
    # --Slicer_transform is the one generated from Initialization
    parser.add_option("-s", "--Slicer_transform", action="store", type="string", dest="Slicer_transform", default='')
    parser.add_option("-i", "--input", action="store", type="string", dest="input", default='')
    parser.add_option("-o", "--output", action="store", type="string", dest="output", default='')
    (opts,args) = parser.parse_args(args)
    
    zipped_xforms = False
    if not opts.output.endswith(".nhdr"):
        print("ERROR: output file must end in .nhdr")
        return
    if not os.path.isfile(opts.input) or not os.path.isfile(opts.Slicer_transform):
        return
    if not os.path.isdir(opts.transform_path):
        return       
    f_ = slicer.util.loadVolume(opts.input)
    landmark_transform_path = opts.Slicer_transform
    transform_dir = opts.transform_path
    # ls for all zipped warp transforms in work folder
    # if empty, then we assume transforms are unzipped
    zipped_xforms = os.listdir(transform_dir)
    zipped_xforms = [x for x in zipped_xforms if x.endswith('Warp.nii.gz')]
    if not zipped_xforms:
        print('found unzipped transforms. using these for speed')
        transform_prefix_list = ['affine0GenericAffine.mat','bspline_syn0Warp.nii','syn_last_Mattes0Warp.nii']
    else:
        transform_prefix_list = ['affine0GenericAffine.mat','bspline_syn0Warp.nii.gz','syn_last_Mattes0Warp.nii.gz']
    transform_list = [os.path.join(transform_dir,transform_prefix_list[i]) for i in range(3)]
    transform_list.insert(0,landmark_transform_path)
    logic = slicer.vtkSlicerTransformLogic()
    node = f_
    for i in range(4):
        print(f'i = {i}')
        transform_file_path = transform_list[i]
        print(transform_file_path)
        transformNode = slicer.util.loadTransform(transform_file_path)
        node.SetAndObserveTransformNodeID(transformNode.GetID())#'list' object has no attribute 'SetAndObserveTransformNodeID'
        node = transformNode
    logic.hardenTransform(f_)
        

    properties = {'useCompression': 0};
    filename = opts.output
    slicer.util.saveNode(f_, filename, properties)
    
    # TODO: error check before closing
    if not os.path.isfile(opts.input):
        print("ERROR: cannot find output file. Check for failures")
        return
    slicer.mrmlScene.RemoveNode(transformNode)
    slicer.mrmlScene.RemoveNode(f_)
    #except:    
    #print("Unexpected error:", sys.exc_info()[0])
    exit() 
if __name__=="__main__":
   ApplyTransforms(sys.argv[1:])

#'K:\CIVM_Apps\Slicer 4.11.20200930\Slicer.exe' --no-splash --no-main-window --python-script "K:/ProjectSpace/yt133/big_disk_space/WorkflowForBXD89/Young/p1_02H_Syto/ControlSlicer-Function.py"  

