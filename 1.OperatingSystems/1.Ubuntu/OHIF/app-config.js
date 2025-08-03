window.config = {
    routerBasename: '/',
    extensions: [],
    modes: [],
    showStudyList: true,
    dataSources: [
      {
        namespace: '@ohif/extension-default.dataSourcesModule.dicomweb',
        sourceName: 'dicomweb',
        configuration: {
          friendlyName: 'dcmjs DICOMWeb Server',
          name: 'DCM4CHEE',
          wadoUriRoot: 'http://172.25.10.8:8099/dcm4chee-arc/aets/DCM4CHEE/wado',
          qidoRoot: 'http://172.25.10.8:8099/dcm4chee-arc/aets/DCM4CHEE/rs',
          wadoRoot: 'http://172.25.10.8:8099/dcm4chee-arc/aets/DCM4CHEE/rs',
          qidoSupportsIncludeField: true,
          supportsReject: true,
          imageRendering: 'wadors',
          thumbnailRendering: 'wadors',
          enableStudyLazyLoad: true,
          supportsFuzzyMatching: true,
          supportsWildcard: true,
        },
      },
    ],
    defaultDataSourceName: 'dicomweb',
  };