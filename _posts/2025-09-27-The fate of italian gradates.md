---
layout: default
title: "The fate of italian graduates"
summary: "An analysis of employment rates and earnings of italian garduates."
plotly: true
---


A country’s prime asset is its talent—the capable people who drive innovation and productivity. Today, that mostly requires deep specialisation in technical fields and an industrial fabric able to absorb those skills and remunerate them fairly. Building such a workforce doesn’t happen spontaneously; it depends on well-structured policies for secondary and tertiary education and credible industrial planning. Italy struggles on both counts, and the gravity of this failure is evident in two indicators for recent graduates: employment rates and salaries. <br>
In this post I examine, through the numbers, the troubling outcomes facing Italy’s early-career cohorts on these two metrics. First, I map the distribution of results across fields of study; then I compare Italy’s performance with other OECD countries.

<div id="graduates-scatter" style="width:100%;height:480px"></div>

<!-- Papa Parse: robust CSV parser in the browser -->
<script defer src="https://cdn.jsdelivr.net/npm/papaparse@5.4.1/papaparse.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', async () => {
  // Build a base-aware URL for GitHub Pages
  const url = "{{ '/data/27-09-2025/graduates_stats_1yr.csv' | relative_url }}"; // Jekyll helper

  // Fetch CSV as text
  const res  = await fetch(url);
  const text = await res.text();

  const parsed = Papa.parse(text, { header: true, dynamicTyping: true });

  const rows = parsed.data.filter(r =>
    r['Field of study'] &&
    r['Employment rate (%)'] != null &&
    r['Net monthly wage (EUR)'] != null &&
    String(r['Field of study']).trim().toLowerCase() !== 'total'
  );

  const x = rows.map(r => r['Employment rate (%)']);   // %
  const y = rows.map(r => r['Net monthly wage (EUR)']); // EUR
  const labels = rows.map(r => r['Field of study']);

  // Build per-point text positions to reduce overlaps
  const median = arr => {
  const s = [...arr].sort((a,b)=>a-b);
  const m = Math.floor(s.length/2);
  return s.length % 2 ? s[m] : (s[m-1]+s[m])/2;
};
const mx = median(x);
const my = median(y);

// Quadrant-based placement: put label away from plot edges & points
const textPositions = x.map((xi, i) => {
  const yi = y[i];
  if (xi >= mx && yi >= my) return 'top left';
  if (xi >= mx && yi <  my) return 'bottom left';
  if (xi <  mx && yi >= my) return 'top right';
  return 'bottom right';
});

// Manual overrides by label (or use indices if you prefer)
const overrides = {
  'Agriculture, Forestry and Veterinary': 'bottom right',
  'Social Sciences and Communication': 'middle left',
  'Literature and Humanities': 'top right'
};

// Apply overrides
textPositions = textPositions.map((pos, i) =>
  overrides[labels[i]] ?? pos
);

const trace = {
  type: 'scatter',
  mode: 'markers+text',
  x, y,
  text: labels,
  textposition: textPositions,    // per-point placement
  textfont: { size: 11 },         // small, readable
  hovertemplate:
    'Employment: %{x:.1f}%<br>Wage: €%{y:.0f}<extra></extra>',
  marker: { size: 8, opacity: 0.9 },
  cliponaxis: false               // let labels spill past the axes margin
};

  const layout = {
    margin: { t: 30, r: 20, b: 60, l: 70 },
    xaxis: {
      title: 'Employment rate (%)',
      ticksuffix: '%',
      zeroline: false,
      fixedrange: true            // disable zoom/pan on x
    },
    yaxis: {
      title: 'Net monthly wage (EUR)',
      zeroline: false,
      fixedrange: true            // disable zoom/pan on y
    },
    hovermode: 'closest'
  };

  const config = {
    responsive: true,
    displayModeBar: false, // hide toolbar
    scrollZoom: false,
    doubleClick: false,
    displaylogo: false
  };

  Plotly.newPlot('graduates-scatter', [trace], layout, config);
});
</script>
