import bentoml
from dynamo.runtime import EtcdKvCache  # This is failing

@bentoml.service
class Frontend:
    def __init__(self):
        self.cache = EtcdKvCache()
    
    @bentoml.api
    def chat(self, request):
        return {"response": "test"}
