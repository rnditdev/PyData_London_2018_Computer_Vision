!git clone https://github.com/matterport/Mask_RCNN.git
cd Mask_RCNN
cd samples
wget https://s3.amazonaws.com/italia18/dataset_segmentation.zip
unzip dataset_segmentation
cd dataset_segmentation
./segmentation.py train --dataset=./ --weights=coco