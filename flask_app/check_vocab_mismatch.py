import joblib
import mlflow

# Load your local vectorizer
local_vec = joblib.load("../tfidf_vectorizer.pkl")
local_features = set(local_vec.get_feature_names_out())

# Load MLflow model vectorizer feature names from model metadata
mlflow.set_tracking_uri("http://ec2-18-189-13-9.us-east-2.compute.amazonaws.com:8000")
model_uri = "models:/yt_chrome_plugin_model/24"
model = mlflow.pyfunc.load_model(model_uri)

try:
    mlflow_features = set(model.metadata.get_input_schema().input_names())
    print("✅ Common features:", len(local_features & mlflow_features))
    print("❌ Only in local vectorizer:", len(local_features - mlflow_features))
    print("❌ Only in MLflow model:", len(mlflow_features - local_features))
except Exception as e:
    print("Could not fetch schema directly:", e)
