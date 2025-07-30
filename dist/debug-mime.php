<?php
// Debug MIME types on server
header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html>
<head>
    <title>MIME Type Debug</title>
</head>
<body>
    <h1>Server MIME Type Debug</h1>
    
    <h2>Server Information:</h2>
    <p><strong>Server:</strong> <?php echo $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown'; ?></p>
    <p><strong>PHP Version:</strong> <?php echo phpversion(); ?></p>
    
    <h2>JavaScript File Test:</h2>
    <p>Testing how server serves .js files...</p>
    <script>
        fetch('/assets/index-BUBO90mG.js', {method: 'HEAD'})
            .then(response => {
                console.log('Content-Type:', response.headers.get('content-type'));
                document.getElementById('mime-result').innerHTML = 
                    '<strong>MIME Type:</strong> ' + response.headers.get('content-type');
            })
            .catch(err => {
                document.getElementById('mime-result').innerHTML = 
                    '<strong>Error:</strong> ' + err.message;
            });
    </script>
    <div id="mime-result">Loading...</div>
    
    <h2>Solutions if MIME type is wrong:</h2>
    <ol>
        <li>Ensure .htaccess file is uploaded</li>
        <li>Check if hosting supports .htaccess</li>
        <li>Contact hosting provider</li>
        <li>Try uploading to a subdirectory</li>
    </ol>
</body>
</html>
