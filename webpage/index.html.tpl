<!DOCTYPE html>
<html>
<head>
  <title>File Upload</title>
</head>
<body>
  <h1>Upload a File</h1>
  <input type="file" id="fileInput">
  <button onclick="uploadFile()">Upload</button>

  <script>
    async function uploadFile() {
      const fileInput = document.getElementById('fileInput');
      const file = fileInput.files[0];
      const sasUrl = "https://${storage_account_name}.blob.core.windows.net/${container_name}/$${file.name}${sas_token}";

      const uploadUrl = `$${sasUrl}&$${file.name}`;
      const response = await fetch(uploadUrl, {
        method: 'PUT',
        headers: {
          'x-ms-blob-type': 'BlockBlob'
        },
        body: file
      });

      if (response.ok) {
        alert('File uploaded successfully!');
      } else {
        alert('File upload failed!');
      }
    }
  </script>
</body>
</html>