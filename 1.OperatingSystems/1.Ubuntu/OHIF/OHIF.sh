# -------==========------- 
# OHIF
# -------==========------- 

# Clone OHIF Directory
mkdir -p ~/docker
cp -R ~/DevOps-Notebook/1.OperatingSystems/1.Ubuntu/OHIF ~/docker/ohif
cd ~/docker/ohif

# Make OHIF Directory
sudo mkdir -p /mnt/data/ohif/

# Set Permissions
# sudo chmod 666 /mnt/data/ohif/app-config.js

# Create the docker volumes for the containers.
docker volume create \
      --driver local \
      --opt type=none \
      --opt device=/mnt/data/ohif \
      --opt o=bind ohif-data
  
# Check and Edit .env file
nano .env

# Create Network and Run
# Note: Check firewall & mapping rules for Port: 80 & 443
docker compose pull
docker compose up -d

# OHIF App Config
sudo nano /mnt/data/ohif/app-config.js

# -------==========------- 
# DICOM test studies
# -------==========------- 
DVTK Storage SCU Emulator
https://www.dvtk.org/downloads/

DICOM test studies
https://www.pcir.org/researchers/downloads_available.html


# -------==========------- 
# DICOM Datasource
# -------==========------- 
      {
        namespace: '@ohif/extension-default.dataSourcesModule.dicomweb',
        sourceName: 'dicomweb3',
        configuration: {
          friendlyName: 'DCM4CHEE',
          name: 'DCM4CHEE',
          wadoUriRoot: 'http://172.25.10.8:8099/dcm4chee-arc/aets/DCM4CHEE/wado',
          qidoRoot: 'http://172.25.10.8:8099/dcm4chee-arc/aets/DCM4CHEE/rs',
          wadoRoot: 'http://172.25.10.8:8099/dcm4chee-arc/aets/DCM4CHEE/rs',
          qidoSupportsIncludeField: false,
          imageRendering: 'wadors',
          thumbnailRendering: 'wadors',
          enableStudyLazyLoad: true,
          supportsFuzzyMatching: false,
          supportsWildcard: true,
          staticWado: true,
          singlepart: 'bulkdata,video',
          // whether the data source should use retrieveBulkData to grab metadata,
          // and in case of relative path, what would it be relative to, options
          // are in the series level or study level (some servers like series some study)
          bulkDataURI: {
            enabled: true,
            relativeResolution: 'studies',
          },
          omitQuotationForMultipartRequest: true,
        },
      }