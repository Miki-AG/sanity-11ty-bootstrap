# Sanity + 11ty + Bootstrap

This project provides a set of scripts to quickly generate and run a new web project using Sanity.io as a headless CMS, 11ty as a static site generator, and Bootstrap for styling.

## Requirements

Before you begin, ensure you have the following installed:

*   [Node.js](https://nodejs.org/) (which includes npm)
*   [Sanity CLI](https://www.sanity.io/docs/cli): `npm install -g @sanity/cli`
*   [PM2](https://pm2.keymetrics.io/): `npm install -g pm2`

You will also need a Sanity.io account.

## Setup

1.  **Create a Sanity Project:**
    Go to [sanity.io/manage](https://sanity.io/manage) and create a new project. Once it's created, you will be able to find your `projectId` in the project settings. You will need this for the `.env` file.

2.  **Clone this repository:**
    ```bash
    git clone https://github.com/your-username/sanity-11ty-bootstrap.git
    cd sanity-11ty-bootstrap
    ```

3.  **Create a `.env` file:**
    Create a file named `.env` in the root of the project and add the following, replacing the placeholder values with your own:
    ```
    PROJECT_NAME="my-awesome-project"
    SANITY_PROJECT_ID="your-sanity-project-id"
    SANITY_DATASET="production"
    ```
    *   `PROJECT_NAME`: The name of the directory that will be created for your new project.
    *   `SANITY_PROJECT_ID`: Your Sanity project ID from the previous step.
    *   `SANITY_DATASET`: The name of your Sanity dataset (e.g., "production").

4.  **Log in to Sanity:**
    If you haven't already, log in to your Sanity account from the command line:
    ```bash
    sanity login
    ```

## Usage

### 1. Generate the Project

Run the `generate.sh` script to create your new project based on the values in your `.env` file:

```bash
./generate.sh
```

This will create a new directory with the name you specified in `PROJECT_NAME`. Inside this directory, you will find two subdirectories: `cms` (for Sanity Studio) and `web` (for your 11ty site).

### 2. Run the Development Servers

To start the development servers for both Sanity Studio and your 11ty site, use the `serve.sh` script:

```bash
./serve.sh
```

This script uses `pm2` to run the servers in the background. It will also automatically open your new site and Sanity Studio in your web browser.

*   **11ty Site:** `http://localhost:8080`
*   **Sanity Studio:** `http://localhost:3333`

### 3. Stop the Development Servers

To stop all running development servers, use the `stop.sh` script:

```bash
./stop.sh
```

This will stop the `pm2` processes for the 11ty site, Sanity Studio, and the content listener.
