import requests
import sys

print("Calling httpbin")
r = requests.get('https://httpbin.org/get')
print("Response", r.text)
print("Status code", r.status_code)
success = r.status_code == 200
if success:
    print("Successfully called httpbin")
else:
    print("Failed to call httpbin")
    sys.exit(1)

