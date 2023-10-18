# ca-scripts
Collection of bash scripts for manage OpenSSL CA
It is based from article published by Jamie Nguyen (https://jamielinux.com/docs/openssl-certificate-authority/)

## Install 

#### 1. Run 
```
chmod +x install.sh
```
```
./install.sh
```

### 3. Set Path
```
export PATH=$PATH:$CA_HOME\scripts
```


## Command

|Command                           | Description                                                                         |
|----------------------------------|-------------------------------------------------------------------------------------|
|create-certificate.sh             | create self signed certificate. ```create-certificate CA_NAME CERT_NAME CERT_TYPE```|
|export-certificate.sh             | package the cert with private and chain to tar file                                 |
|setup-ca.sh                       | setup new CA with root and intermediate                                             |

