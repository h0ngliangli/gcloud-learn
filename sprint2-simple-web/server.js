const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello from App Engine! This is just a simple web app that \
            can be deployed in Google\'s App Engine.<p> \
            gcloud app deploy');
});

// Listen to the App Engine-specified port, or 8080 otherwise
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}...`);
});