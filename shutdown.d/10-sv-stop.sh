msg "Waiting for services to stop..."
sv force-stop /var/service/*
sv exit /var/service/*
