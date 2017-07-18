# Built on fast.ai script: https://github.com/fastai/courses/blob/master/setup/install-gpu.sh
# Original license at https://github.com/fastai/courses/blob/master/LICENSE.txt
#
# All revisions and additions:
# Copyright 2017 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Script is designed to work with ubuntu 16.04 LTS

# ensure system is updated and has basic build tools
sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils
sudo apt-get --assume-yes install software-properties-common
sudo apt-get --assume-yes install htop

# download and install GPU drivers
echo
echo "**************** Cuda Install *******************"
echo
wget "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb" -O "cuda-repo-ubuntu1604_8.0.44-1_amd64.deb"

sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get -y install cuda
sudo modprobe nvidia
nvidia-smi

# install cudnn libraries
echo
echo "**************** cuDNN Install *******************"
echo
wget "http://files.fast.ai/files/cudnn.tgz" -O "cudnn.tgz"
tar -zxf cudnn.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/* /usr/local/cuda/include/
cd ~

# install Anaconda for current user
echo
echo "**************** Anaconda Install *******************"
echo
mkdir downloads
cd downloads
wget "https://repo.continuum.io/archive/Anaconda2-4.4.0-Linux-x86_64.sh" -O "Anaconda2-4.4.0-Linux-x86_64.sh"
bash "Anaconda2-4.2.0-Linux-x86_64.sh" -b

echo "export PATH=\"$HOME/anaconda2/bin:\$PATH\"" >> ~/.bashrc
export PATH="$HOME/anaconda2/bin:$PATH"
conda install -y bcolz
conda upgrade -y --all

# install and configure theano
echo
echo "**************** Theano Install *******************"
echo
pip install theano
echo "[global]
device = gpu
floatX = float32

[cuda]
root = /usr/local/cuda" > ~/.theanorc

# install and configure tensorflow (https://www.tensorflow.org/install/install_linux#InstallingNativePip)
echo
echo "**************** TensorFlow Install *******************"
echo
sudo apt-get --assume-yes install python-pip python-de # for Python 2.7
sudo apt-get --assume-yes install libcupti-dev
pip install tensorflow-gpu

# install and configure keras (https://keras.io/#installation)
echo
echo "**************** Keras Install *******************"
echo
pip install keras==2.0.1
mkdir ~/.keras
echo '{
    "image_dim_ordering": "th",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "theano"
}' > ~/.keras/keras.json

# install and configure pytorch (http://pytorch.org/)
echo
echo "**************** PyTorch Install *******************"
echo
pip install http://download.pytorch.org/whl/cu80/torch-0.1.12.post2-cp27-none-linux_x86_64.whl 
pip install torchvision
# h5py
sudo apt-get --assume-yes install libhdf5-dev
pip install h5py
#Protocol Buffers 3
curl -OL https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip
unzip protoc-3.2.0-linux-x86_64.zip -d protoc3
sudo mv protoc3/bin/protoc /usr/bin/protoc
#LMDP
pip install lmdb

# configure jupyter and prompt for password
echo
echo "**************** Jupyter Install *******************"
echo
jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "If you setup firewall rules to access \"jupyter notebook\" on this VM then it will start Jupyter on port 8888"
echo "If you get an error instead, try restarting your session so your $PATH is updated"

sudo apt-get update
mkdir code && cd code
	
echo
echo "Setup complete"
