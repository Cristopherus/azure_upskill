<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload File to Azure Storage</title>
</head>
<body>
    <h1>Upload File to Azure Storage</h1>
    <input type="file" id="fileInput">
    <button onclick="uploadFile()">Upload</button>

    <script>
        async function uploadFile() {
            const fileInput = document.getElementById('fileInput');
            const file = fileInput.files[0];

            if (!file) {
                alert('Please select a file first');
                return;
            };

            const blobUrl = "https://${storage_account_name}.blob.core.windows.net/${container_name}/$${file.name}?${sas_token}";

            try {
                const response = await fetch(blobUrl, {
                    method: 'PUT',
                    headers: {
                        'x-ms-blob-type': 'BlockBlob'
                    },
                    body: file
                });

                if (response.ok) {
                    alert('File uploaded successfully!');
                } else {
                    const errorText = await response.text();
                    alert(`Error uploading file: $${response.statusText}\n$${errorText}`);
                }
            } catch (error) {
                console.error('Error uploading file:', error);
                alert(`Error uploading file: $${error.message}`);
            }
        }
    </script>
</body>
</html>

