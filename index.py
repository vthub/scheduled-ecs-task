import requests, sys

print("Calling httpbin")

r = requests.get('https://httpbin.org/get')
if r.status_code != 200:
    print("Failed")
    sys.exit(1)

print("Successfully completed")


