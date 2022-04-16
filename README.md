# Rent Remedy

Rent management tool to facilitate communication between landlords and tenants, mange/pay rent, and file maintenance reports. 

# Onboard Tenant
## Onboard Tenant
![onboarding](https://user-images.githubusercontent.com/96437864/163681774-baa16da8-1525-43a2-9b81-83e3becd2f0c.gif)


- Onboard Tenant


Set up Flutter https://flutter.dev/docs/get-started/install

1. Download flutter SDK
2. Update path
3. Run "flutter doctor" in terminal
4. Download IDE
   4a. Download flutter plugin in IDE
   4b. Configure dart and flutter path in IDE
   4c. Set up android emulator in IDE

Create a file called ".env.development" at the base directory for the project with the following variables:

API_URL=http://'your ip4 address':5000
WEBSOCKET=ws://'your ip4 address':5000

Create a file called ".env.production" at the base directory for the project with the following variables:

API_URL=https://api.myrentremedy.com
WEBSOCKET=wss://api.myrentremedy.com
