@Library('iaslab-pipeline-library@v1.1') _

standardPipeline(
    serviceName: 'microservicio-backend',
    buildType: 'maven',
    jdkVersion: '17',
    publishJar: true,
    publishDocker: true,
    nexusHost: '54.147.16.19',    // <--- Coloca aquí la IP pública de tu ec2-nexus
    dockerPort: '9080',
    deployTarget: '100.57.91.49', // <--- Coloca aquí la IP pública de tu ec2-deploy
    healthEndpoint: '/api/products' // Endpoint que responde 200 OK
)