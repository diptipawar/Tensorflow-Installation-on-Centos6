#Tensorflow Installation on Centos6

#Python 2.7 (for TensorFlow)
#Install the necessary packages
yum install python27 python27-numpy python27-python-devel python27-python-wheel

# first install the scl
yum install centos-release-scl

# install the toolset version 6
yum install devtoolset-6 # this provides GCC-6.x.x

#Build and Install Bazel
scl enable devtoolset-6 bash

# download distribution archive
wget https://github.com/bazelbuild/bazel/releases/download/0.9.0/bazel-0.9.0-dist.zip
unzip bazel-0.9.0-dist.zip -d bazel-0.9.0-dist
cd bazel-0.9.0-dist

# clone source code repository
git clone https://github.com/bazelbuild/bazel.git
cd bazel

# select version (optional)
git checkout 0.4.0

# compile
./compile.sh

# install
mkdir -p ~/bin
cp output/bazel ~/bin/

# exit from Software Collection environment
exit


#Build TensorFlow with Bazel
scl enable devtoolset-6 python27 bash

# clone source code repository
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow

# select version (optional)
git checkout v1.5.0


#Modify tf_extension_linkopts function in tensorflow/tensorflow.bzl from
name,
srcs=[],
deps=[]
-linkopts=[],
+linkopts=[“-lrt”]
framework_so=tf_binary_additional_srcs(),

def tf_extension_linkopts():
- return [] # No extension link opts
+ return ["-lrt"] # No extension link opts
#Build


#After above modification, we can now start building!
# configure workspace
export \
    PYTHON_BIN_PATH=/opt/rh/python27/root/usr/bin/python \
    PYTHON_LIB_PATH=/opt/rh/python27/root/usr/lib/python2.7/site-packages \
    TF_NEED_JEMALLOC=0 \
    TF_NEED_GCP=0 \
    TF_NEED_HDFS=0 \
    TF_NEED_S3=0 \
    TF_ENABLE_XLA=0 \
    TF_NEED_GDR=0 \
    TF_NEED_VERBS=0 \
    TF_NEED_OPENCL=0 \
    TF_NEED_CUDA=0 \
    TF_NEED_MPI=0 \
    CC_OPT_FLAGS="-march=native"
./configure


# build for CPU
~/bin/bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

# build for GPU
$ bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

# exit from Software Collection environment
exit

#Finishing Up- Finally, you will found a tensorflow-1.5.0-cp27-none-linux_x86_64.whl (filename may vary upon versions) in /tmp/tensorflow_pkg/. With this self-built binary package, we can now deploy TensorFlow to CentOS 6 by pip.

#install by pip 
sudo scl enable python27 
pip install tensorflow-1.5.0-cp27-none-linux_x86_64.whl
