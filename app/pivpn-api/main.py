from fastapi import FastAPI
from wakeonlan import send_magic_packet

app = FastAPI()

# Replace with your PC's MAC address
PC_MAC_ADDRESS = "00:11:22:33:44:55"

@app.get("/wake")
async def wake_pc():
    try:
        send_magic_packet(PC_MAC_ADDRESS)
        return {"message": "Wake-on-LAN packet sent successfully"}
    except Exception as e:
        return {"error": f"Failed to send Wake-on-LAN packet: {str(e)}"}

@app.get("/")
async def root():
    return {"message": "Welcome to the Wake-on-LAN API"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

