#!/bin/bash


print_structure() {
    walk_dir() {
        local dir="$1"
        local prefix="$2"
        for file in "$dir"/*; do
            local name="${file##*/}"
            if [ -d "$file" ]; then
                echo "${prefix}└── [DIR]  $name"
                walk_dir "$file" "$prefix    "
            else
                echo "${prefix}├── [FILE] $name"
            fi
        done
    }
    walk_dir "." ""
}


case "$1" in
    build_generator)
        docker build -t generator -f Dockerfile.generator .
        ;;
    run_generator)
        mkdir -p data
        docker run --rm -v "$(pwd)/data:/data" generator
        echo "Generated data/data.csv"
        ;;
    create_local_data)
        mkdir -p local_data
        python3 generate.py local_data
        echo "Generated local_data/data.csv"
        ;;
    build_reporter)
        docker build -t reporter -f Dockerfile.reporter .
        ;;
    run_reporter)
        mkdir -p data
        docker run --rm -v "$(pwd)/data:/data" reporter
        ;;
    structure)
        print_structure
        ;;
    clear_data)
        rm -f data/*.csv data/*.html
        echo "Cleaned data/ (all .csv and .html removed)"
        ;;
    inside_generator)
        docker run --rm -v "$(pwd)/data:/data" generator ls -la /data
        ;;
    inside_reporter)
        docker run --rm -v "$(pwd)/data:/data" reporter ls -la /data
        ;;
    report_server)
        if [ ! -f "data/report.html" ]; then
            echo "Error: data/report.html not found. Run './run.sh run_reporter' first."
            exit 1
        fi
        docker rm -f report_server 2>/dev/null || true
        docker run -d -p 8080:80 -v "$(pwd)/data:/usr/share/nginx/html" --name report_server nginx:alpine
        echo "Web server running on port 8080"
        #я пытался в код удобно встроить, но ссылка не открывается. Хром считает меня злоумышленником ( ˘︹˘ )
        # if [ -n "$CODESPACES" ]; then
        #     CODESPACE_URL="https://${CODESPACE_NAME}-8080.preview.app.github.dev/report.html"
        #     echo "Open report: $CODESPACE_URL"
        # else
        #     echo "Open report: http://localhost:8080/report.html"
        # fi
        ;;
    *)
        exit 1
        ;;
esac