# jitsi-auth-portal
Jitsi Keycloak Authentication Portal

Environment Variables

PORT = Port for Gunicorn to listen on
NUM_WORKERS = Number of worker processes Gunicorn should use to service requests

A config volume should be provided and mounted to /config in the container
