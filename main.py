import psycopg2
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer

# database connection
def connectDb(db, usr, pass_, host, port):
    conn = psycopg2.connect(database=db, user=usr, password=pass_, host=host, port=port);
    return conn

# get data from db
def getCommentsCorpus(conn):
    data = pd.read_sql("select \"VIOLATION INSPECTOR COMMENTS\" from mario_k.\"Building_Violations\"", conn);
    # put data to list for vectorizer
    corpus1 = data["VIOLATION INSPECTOR COMMENTS"].tolist();
    corpus = [];
    # add empty string for missing values
    for a in corpus1:
        if a is None:
            corpus.append('');
        else:
            corpus.append(a);
    return corpus;

def createTextFeatures(corpus):
    # create vectorizer (tokenizer)
    vectorizer = CountVectorizer(lowercase=True, max_df=1.0, min_df=0.0, ngram_range=(1, 1), preprocessor=None, stop_words='english');

    # create matrix of bag-of-words vectors
    bow = vectorizer.fit_transform(corpus);

    print('creating bow');

    # tf-idf weighting of bow
    transformer = TfidfTransformer();
    tfidf = transformer.fit_transform(bow)

    # column sums of the matrix - word freq in corpus
    col_sum = bow.sum(axis=0)
    col_sum_arr = np.squeeze(np.asarray(col_sum))

    # row sums of the matrix - comment sizes
    row_sum = bow.sum(axis=1)
    row_sum_arr = np.squeeze(np.asarray(row_sum))

# connect to db
conn = connectDb("training_2015", "karlovcec", "karlovcec", "dssgsummer2014postgres.c5faqozfo86k.us-west-2.rds.amazonaws.com", "5432");

print('Creating text features');

# create vectorizer (tokenizer)
vectorizer = CountVectorizer(lowercase=True, max_df=1.0, min_df=0.0, ngram_range=(1, 1), preprocessor=None, stop_words='english');

# get comments data corpus
corpus = getCommentsCorpus(conn);

# create matrix of bag-of-words vectors
bow = vectorizer.fit_transform(corpus);

# tf-idf weighting of bow
transformer = TfidfTransformer();
tfidf = transformer.fit_transform(bow)

# column sums of the matrix - word freq in corpus
col_sum = bow.sum(axis=0)
col_sum_arr = np.squeeze(np.asarray(col_sum))

# row sums of the matrix - comment sizes
row_sum = bow.sum(axis=1)
row_sum_arr = np.squeeze(np.asarray(row_sum))

print('Done');

