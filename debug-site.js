import https from 'https';
import fs from 'fs';

const SITE_URL = 'password.0xpacman.com';

console.log('🔍 Advanced Site Debugging');
console.log('==========================\n');

// Function to make HTTPS requests
function makeRequest(path, method = 'GET') {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: SITE_URL,
            port: 443,
            path: path,
            method: method,
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            }
        };

        const req = https.request(options, (res) => {
            let data = '';
            res.on('data', (chunk) => data += chunk);
            res.on('end', () => resolve({ 
                statusCode: res.statusCode, 
                headers: res.headers, 
                data: data 
            }));
        });

        req.on('error', reject);
        req.setTimeout(10000, () => reject(new Error('Timeout')));
        req.end();
    });
}

async function debugSite() {
    try {
        console.log('1. Fetching main page...');
        const mainPage = await makeRequest('/');
        
        console.log(`Status: ${mainPage.statusCode}`);
        console.log(`Content-Type: ${mainPage.headers['content-type']}`);
        console.log(`Content-Length: ${mainPage.data.length} bytes\n`);

        if (mainPage.statusCode !== 200) {
            console.log('❌ Main page not loading correctly');
            console.log('Response:', mainPage.data.substring(0, 500));
            return;
        }

        // Extract JavaScript file paths from HTML
        const jsMatches = mainPage.data.match(/src="([^"]*\.js)"/g);
        const cssMatches = mainPage.data.match(/href="([^"]*\.css)"/g);
        
        console.log('2. Found assets:');
        console.log('JavaScript files:', jsMatches || 'None found');
        console.log('CSS files:', cssMatches || 'None found');
        console.log('');

        // Test JavaScript file MIME type
        if (jsMatches && jsMatches.length > 0) {
            const jsPath = jsMatches[0].match(/src="([^"]*)"/)[1];
            console.log(`3. Testing JavaScript file: ${jsPath}`);
            
            try {
                const jsResponse = await makeRequest(jsPath, 'HEAD');
                console.log(`JS Status: ${jsResponse.statusCode}`);
                console.log(`JS Content-Type: ${jsResponse.headers['content-type']}`);
                
                if (jsResponse.headers['content-type']?.includes('video/mp2t')) {
                    console.log('❌ FOUND THE PROBLEM: JS file served as video/mp2t');
                } else if (jsResponse.headers['content-type']?.includes('application/javascript')) {
                    console.log('✅ JS file MIME type is correct');
                } else {
                    console.log(`⚠️  Unexpected MIME type: ${jsResponse.headers['content-type']}`);
                }
            } catch (err) {
                console.log(`❌ Error fetching JS file: ${err.message}`);
            }
        } else {
            console.log('❌ No JavaScript files found in HTML');
            console.log('HTML sample (first 1000 chars):');
            console.log(mainPage.data.substring(0, 1000));
        }

        console.log('\n4. Testing .htaccess functionality...');
        console.log('Security headers:');
        console.log(`X-Frame-Options: ${mainPage.headers['x-frame-options'] || 'Missing'}`);
        console.log(`X-Content-Type-Options: ${mainPage.headers['x-content-type-options'] || 'Missing'}`);
        console.log(`X-XSS-Protection: ${mainPage.headers['x-xss-protection'] || 'Missing'}`);

        // Test if .htaccess is working by checking if TypeScript files are blocked
        console.log('\n5. Testing TypeScript file blocking...');
        try {
            const tsResponse = await makeRequest('/src/main.ts', 'HEAD');
            if (tsResponse.statusCode === 403) {
                console.log('✅ TypeScript files properly blocked');
            } else {
                console.log(`⚠️  TypeScript file accessible (Status: ${tsResponse.statusCode})`);
            }
        } catch (err) {
            console.log('✅ TypeScript files blocked (connection refused)');
        }

    } catch (error) {
        console.log(`❌ Error: ${error.message}`);
    }
}

// Generate fix recommendations
function generateFixes() {
    console.log('\n🔧 RECOMMENDED FIXES:');
    console.log('=====================');
    console.log('1. Re-upload the entire dist/ folder contents');
    console.log('2. Ensure .htaccess file is uploaded (check file manager)');
    console.log('3. If using cPanel, check "Show Hidden Files" option');
    console.log('4. Contact hosting provider about .htaccess support');
    console.log('5. Try uploading to a subdirectory first');
    console.log('6. Clear all browser cache and try incognito mode');
}

debugSite().then(() => {
    generateFixes();
}).catch(console.error);
