# SSEGCN-ABSA
Code and datasets of our paper "SSEGCN: Syntactic and Semantic Enhanced Graph Convolutional Network for Aspect-based Sentiment Analysis" accepted by NAACL 2022.



## Requirements

- torch==1.4.0
- scikit-learn==0.23.2
- transformers==3.2.0
- cython==0.29.13
- nltk==3.5

Install requirements:

```bash
pip install -r requirements.txt
```

or build with Docker:

```bash
docker build -t ssegcn:latest .
docker run --gpus all -it --name ssegcn-container ssegcn:latest /bin/bash
```

## Preparation

1. Download and unzip GloVe vectors(`glove.840B.300d.zip`) from [https://nlp.stanford.edu/projects/glove/](https://nlp.stanford.edu/projects/glove/) and put it into  `SSEGCN/glove` directory. (Skip this step if using the provided Dockerfile, which downloads it automatically.)

2. Prepare dataset with:

   change directory into `dataset` and run:

   `python preprocess_data.py`

3. Prepare vocabulary with:

   `sh build_vocab.sh`

## Training

To train the SSEGCN model, run:

`sh run.sh`

## Credits

The code and datasets in this repository are based on [DualGCN_ABSA](https://github.com/CCChenhao997/DualGCN-ABSA) .