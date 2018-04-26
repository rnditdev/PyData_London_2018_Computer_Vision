 
sudo apt-get install -y python-pip
sudo apt-get install -y protobuf-compiler python-pil python-lxml python-tk unzip
sudo pip install Cython
sudo pip install jupyter
sudo pip install matplotlib
sudo pip install pandas
sudo pip install tensorflow

git clone https://github.com/tensorflow/models.git
cd models
git checkout 079d67d9a0b3407e8d074a200780f3835413ef99
cd research
export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
protoc object_detection/protos/*.proto --python_out=.
python setup.py build
python setup.py install
cd object_detection
wget https://s3.amazonaws.com/italia18/dataset_italia_final.zip
unzip dataset_italia_final.zip

wget http://download.tensorflow.org/models/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz
tar -zxvf faster_rcnn_inception_v2_coco_2018_01_28.tar.gz

python xml_to_csv.py

python generate_tfrecord.py --csv_input=images/train_labels.csv --image_dir=images/train --output_path=train.record
python generate_tfrecord.py --csv_input=images/test_labels.csv --image_dir=images/test --output_path=test.record
	
python train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/faster_rcnn_inception_v2_pets.config

python export_inference_graph.py --input_type image_tensor --pipeline_config_path training/faster_rcnn_inception_v2_pets.config --trained_checkpoint_prefix training/model.ckpt-20000 --output_directory inference_graph
