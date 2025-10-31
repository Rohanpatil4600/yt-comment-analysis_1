import joblib
v = joblib.load("tfidf_vectorizer.pkl")
print("Feature count:", len(v.get_feature_names_out()))
