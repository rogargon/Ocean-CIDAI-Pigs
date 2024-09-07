echo "Processing input path"
jq -r '.[]' <(echo $DIDS) | while read did; do
  unzip -o "/data/inputs/$did/0" -d /workdir/input;
  python /workdir/src/predict_path.py -c /workdir/model/config.yaml -w /workdir/model/model.pth -i /workdir/input -o "/workdir/output" --use-cuda;
  python /workdir/src/NTracker/main.py --config-name coco_pigs images_path="/workdir/input" annotations_path="/workdir/output/" hydra.run.dir="/workdir/output/tracking/"
  rm -r /workdir/input;
done

echo "Exporting outputs"
cp /workdir/output/tracking/walk.json /data/outputs/walking.json
cp /workdir/output/tracking/time_on_area/drink_area.json /data/outputs/drinking_area.json
cp /workdir/output/tracking/time_on_area/roi_0.json /data/outputs/feeding_area.json
cp /workdir/output/tracking/tracking.mp4 /data/outputs/tracking.mp4
