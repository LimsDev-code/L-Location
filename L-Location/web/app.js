// Wait for the page to fully load
window.addEventListener('load', () => {
    const container = document.querySelector('.container');
    container.style.visibility = 'hidden'; // Hide the interface by default

    // Listen for messages sent from the client
    window.addEventListener('message', (event) => {
        const data = event.data;

        if (data.action === 'open') {
            container.style.visibility = 'visible'; // Show the interface
        } else if (data.action === 'close') {
            container.style.visibility = 'hidden'; // Hide the interface
        }
    });

    // Close the interface with the Escape key
    window.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            fetch('https://Llocation/closeall'); // Call the endpoint to close
        }
    });

    // Handle the click on the "lSpawn" button
    document.querySelector('#lSpawn').addEventListener('click', () => {
        const durationSelect = document.getElementById('guests'); // Get the selected duration
        const duration = parseInt(durationSelect.value) * 60 * 1000; // Convert to milliseconds

        // Send a request to spawn the vehicle
        fetch('https://Llocation/lSpawn')
            .then(() => {
                // Set a timeout to despawn the vehicle
                setTimeout(() => {
                    fetch('https://Llocation/vehicleDespawn'); // Call the endpoint to despawn
                }, duration);
            })
            .catch((error) => {
                console.error('Error while spawning the vehicle:', error);
            });
    });
});