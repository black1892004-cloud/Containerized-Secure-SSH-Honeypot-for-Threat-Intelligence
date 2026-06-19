# Containerized Secure SSH Honeypot for Threat Intelligence

## Project Overview
This project implements a high-fidelity SSH honeypot using Cowrie, containerized with Docker, to attract and analyze attacker behavior without risking real systems. The primary goal is to gather actionable threat intelligence by observing attacker tactics, techniques, and procedures (TTPs) in a controlled, isolated environment.

## Key Features

*   **Containerized for Safety**: Utilizes Docker containers to provide robust isolation, ensuring that even if an attacker compromises the honeypot, the host system remains secure.
*   **High-Fidelity Deception**: Employs advanced filesystem engineering and persona customization to create a highly realistic decoy system that mimics a production server, increasing attacker dwell time and data quality.
*   **Custom Filesystem (`fs.pickle`)**: Modified using `fsctl.py` to build a convincing directory structure and plant decoy files (honeyfiles) such as `.env` files with fake API keys, `backup.sql` files, and `bash_history` logs.
*   **Persona Customization**: Created multiple user accounts (e.g., `sysadmin`, `oracle`, `abdallah`, `root`) with logical file ownership and permissions to enhance realism.
*   **Active Defense**: Integrated decoy payloads (generated with `msfvenom`) to test attacker reactions and potentially gather more information.
*   **Easy Deployment & Scalability**: Docker-Compose facilitates quick setup and expansion, enabling the deployment of multiple honeypots (Honeynet) for broader threat detection.
*   **Real-time Threat Intelligence**: Captures detailed logs of attacker interactions, commands executed, and uploaded malware, providing immediate insights into attack methodologies.

## Architecture

![Architecture Diagram](architecture.png)

The diagram above illustrates the high-level architecture of the system:
1.  **Attacker**: Initiates SSH connection on port 22.
2.  **Docker Host**: Receives the connection and forwards it to the Cowrie container.
3.  **Cowrie Container**: The core of the honeypot, providing the interactive shell.
4.  **Filesystem Engineering**: A customized `fs.pickle` and `honeyfs` provide a realistic environment.
5.  **Data Capture**: All interactions, logs, and malware samples are captured and stored externally for analysis.

## Getting Started

### Prerequisites
*   Docker and Docker Compose installed on your system.

### Installation and Setup
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/Deception-Engineering-Cowrie-Honeypot.git
    cd Deception-Engineering-Cowrie-Honeypot
    ```
2.  **Build and run the Docker containers:**
    ```bash
    docker-compose up --build -d
    ```
    This will start the Cowrie honeypot in a detached mode.

3.  **Accessing the Honeypot:**
    The honeypot will be accessible via SSH on port `2222` (or as configured in `docker-compose.yml`).
    ```bash
    ssh user@localhost -p 2222
    ```
    (Replace `user` with one of the configured decoy users like `root`, `sysadmin`, `oracle`, etc.)

## Customization

### Filesystem Engineering
To modify the honeypot's filesystem (`fs.pickle`):
1.  Access the Cowrie container's shell:
    ```bash
    docker-compose exec cowrie bash
    ```
2.  Use the `fsctl.py` tool to manipulate `fs.pickle`:
    ```bash
    /opt/cowrie/bin/fsctl.py
    ```
    Refer to Cowrie's official documentation for detailed usage of `fsctl.py`.

### Persona Customization
*   Edit `/opt/cowrie/cowrie-data/honeyfs/etc/passwd` and `/opt/cowrie/cowrie-data/honeyfs/etc/shadow` within the container to add or modify decoy users and their permissions.
*   Place honeyfiles in relevant directories within `honeyfs` (e.g., `/opt/cowrie/cowrie-data/honeyfs/home/sysadmin/`).

## Logging and Analysis

Cowrie logs all attacker interactions, including commands executed, uploaded files, and session data. These logs are typically stored in JSON format and can be found in the `cowrie/var/log/cowrie/` directory (mapped to a Docker volume for persistence).

To view real-time logs:
```bash
tail -f cowrie/var/log/cowrie/cowrie.json
```

## Troubleshooting

*   **Port Conflicts**: Ensure that port `2222` (or your chosen SSH port) is not already in use on your host machine.
*   **Docker Volume Mapping**: Verify that the `cowrie-data` volume is correctly mapped in `docker-compose.yml` to ensure persistence of `honeyfs` and logs.

## Contribution

Feel free to fork this repository, submit pull requests, or open issues for any suggestions or improvements.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.

## Acknowledgements

*   The Cowrie Honeypot Project
*   Docker Community
