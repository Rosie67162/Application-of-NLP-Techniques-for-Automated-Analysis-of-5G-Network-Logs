# Application of NLP Techniques for Automated Analysis of 5G Network Logs

## Overview

This project investigates the application of Natural Language Processing (NLP) techniques for the automated analysis and anomaly detection of 5G network logs.

As 5G networks become increasingly complex, analysing large volumes of network logs manually becomes difficult and time-consuming. This research explores how NLP-based text representations, combined with machine learning classifiers, can be used to identify abnormal patterns in 5G network log data.

The project evaluates different text representation techniques and classification approaches to determine their effectiveness in detecting anomalies in 5G network logs.

## Research Objectives

The main objectives of this research are to:

- Investigate the application of NLP techniques for analysing 5G network logs.
- Evaluate different text representation techniques for extracting meaningful information from network log entries.
- Compare machine learning classifiers for anomaly detection.
- Investigate whether combining different text representations improves detection performance.
- Evaluate the effectiveness of the approaches using standard classification metrics.

## Methodology

The research uses a synthetic dataset consisting of **50,000 generated 5G network log records**. Two experimental categories are investigated.

### 1. Log-Entry-Level Analysis

This category evaluates the classification of individual network log entries using the following text representation techniques:

- TF-IDF
- Word2Vec
- Hybrid TF-IDF and Word2Vec representations

The representations are evaluated using:

- Logistic Regression
- Random Forest

### 2. Session-Level Analysis

This category investigates the classification of network log sessions using:

- TF-IDF
- A project-specific LogBERT-style representation
- Hybrid representations combining TF-IDF and the LogBERT-style approach

The representations are evaluated using:

- Logistic Regression
- Random Forest

A total of **20 experimental configurations** are evaluated across the two categories.

## Technologies and Techniques

| Technology / Technique | Purpose |
|---|---|
| Python | Main programming language |
| Pandas | Dataset processing and manipulation |
| NumPy | Numerical operations |
| Scikit-learn | Machine learning models and evaluation |
| TF-IDF | Text feature extraction |
| Word2Vec | Word embedding representation |
| LogBERT-style model | Session-level log representation |
| Flask | Prototype application backend |
| HTML, CSS and JavaScript | Prototype user interface |

## Prototype Demonstration

The prototype demonstrates the application of the developed approach to 5G network log analysis and anomaly detection.

**Demo Video:** [Watch the Prototype Demonstration](https://youtu.be/5sgNzFvBKyQ)

## Results and Findings

The experimental results demonstrate that NLP-based representations can be effectively applied to the classification of synthetic 5G network log data.

The strongest results obtained in each experimental category were:

| Experimental Category | Best Performing Configuration | F1-Score |
|---|---|---:|
| Log-entry-level | TF-IDF + Logistic Regression | 0.995177 |
| Session-level | TF-IDF + Random Forest | 0.998384 |
| Session-level | TF-IDF + LogBERT-style concatenation + Random Forest | 0.998384 |

The results indicate that TF-IDF achieved strong classification performance across both experimental categories. The hybrid representations did not consistently outperform the strongest standalone approaches.

The models were evaluated using the following performance metrics:

- Accuracy
- Precision
- Recall
- F1-score
- False-positive rate

## Limitations

This research has several limitations that should be considered when interpreting the results:

- The experiments use a synthetic dataset rather than logs collected from a live operational 5G network.
- The LogBERT-style implementation is a project-specific approach and does not represent a complete reproduction of the original LogBERT model.
- The findings demonstrate the potential of the investigated techniques but require further validation using real-world 5G network log data.

## Research Context

This project was completed as part of the COS700 research project.

- **Research Title:** Application of NLP Techniques for Automated Analysis of 5G Network Logs
- **Researcher:** Palesa Rose Tladi
- **Supervisor:** Mr. SM Makura
- **Date:** October 2026

## Acknowledgements

I would like to acknowledge my supervisor, Mr. SM Makura, for his guidance and support throughout this research project.

