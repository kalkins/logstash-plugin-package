#!/bin/sh

for file in ./plugins/*; do
    echo "Installing plugins from $file"
    plugins=""

    while read plugin; do
        echo "Installing $plugin"
        logstash-plugin install $plugin
        plugins="$plugins $plugin"
    done <$file

    version=$(logstash --version | awk '/^logstash/ { print $2 }')
    outdir="out/$(basename $file .txt)"
    outfile=$outdir/logstash-offline-plugins-$version.zip
    mkdir -p $outdir

    echo "Packaging plugins to $outfile"
    logstash-plugin \
        prepare-offline-pack \
        --output "$outfile" \
        --overwrite \
        $plugins
done
