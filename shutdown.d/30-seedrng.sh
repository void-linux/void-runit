if [ -z "$IS_CONTAINER" ]; then
    msg "Saving random number generator seed..."
    seedrng
fi
