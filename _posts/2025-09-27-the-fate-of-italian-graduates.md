---
layout: default
title: "The fate of Italian graduates"
summary: "An analysis of employment rates and earnings of Italian graduates."
plotly: true
---

A country's prime asset is its talent: the capable people who drive innovation and productivity. Today, that mostly requires deep specialisation in technical fields and an industrial fabric able to absorb those skills and remunerate them fairly. Building such a workforce does not happen spontaneously; it depends on well-structured policies for secondary and tertiary education and credible industrial planning. Italy struggles on both counts, and the gravity of this failure is evident in two indicators for recent graduates: employment rates and salaries. <br>
In this post I examine, through the numbers, the troubling outcomes facing Italy's early-career cohorts on these two metrics. First, I map the distribution of results across fields of study; then I compare Italy's performance with other OECD countries.

<div id="graduates-scatter" style="width:100%;height:480px"></div>
<p class="chart-caption">Employment rate vs. net monthly wage for graduates 1 and 5 years after graduation (Source: AlmaLaurea, 2024).</p>

<!-- Papa Parse: robust CSV parser in the browser -->
<script defer src="https://cdn.jsdelivr.net/npm/papaparse@5.4.1/papaparse.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', async () => {
  const chart = document.getElementById('graduates-scatter');

  // Build a base-aware URL for GitHub Pages
  const datasets = [
    {
      name: '1 year',
      url: "{{ '/data/27-09-2025/graduates_stats_1yr.csv' | relative_url }}",
      marker: { size: 8, opacity: 0.85, symbol: 'circle' }
    },
    {
      name: '5 years',
      url: "{{ '/data/27-09-2025/graduates_stats_5yr.csv' | relative_url }}",
      marker: { size: 8, opacity: 0.85, symbol: 'diamond' }
    }
  ];

  try {
    const loadRows = async ({ url }) => {
      const res = await fetch(url);
      if (!res.ok) throw new Error(`Could not load ${url}`);
      const text = await res.text();
      const parsed = Papa.parse(text, { header: true, dynamicTyping: true });

      return parsed.data.filter(r =>
        r['Field of study'] &&
        r['Employment rate (%)'] != null &&
        r['Net monthly wage (EUR)'] != null &&
        String(r['Field of study']).trim().toLowerCase() !== 'total'
      );
    };

    const series = await Promise.all(
      datasets.map(async dataset => ({
        ...dataset,
        rows: await loadRows(dataset)
      }))
    );

    if (series.some(dataset => !dataset.rows.length)) {
      throw new Error('No chart rows found');
    }

    const x = series.flatMap(dataset => dataset.rows.map(r => r['Employment rate (%)']));
    const y = series.flatMap(dataset => dataset.rows.map(r => r['Net monthly wage (EUR)']));
    const xRange = [Math.floor(Math.min(...x) / 5) * 5, Math.ceil(Math.max(...x) / 5) * 5];
    const yRange = [Math.floor(Math.min(...y) / 100) * 100, Math.ceil(Math.max(...y) / 100) * 100];

    const traces = series.map(dataset => {
      const x = dataset.rows.map(r => r['Employment rate (%)']);
      const y = dataset.rows.map(r => r['Net monthly wage (EUR)']);
      const labels = dataset.rows.map(r => r['Field of study']);

      return {
        type: 'scatter',
        mode: 'markers',
        name: dataset.name,
        x, y,
        text: labels,
        hovertemplate:
          `${dataset.name}<br>%{text}<br>Employment: %{x:.1f}%<br>Wage: EUR %{y:.0f}<extra></extra>`,
        marker: dataset.marker,
        cliponaxis: false
      };
    });

    const layout = {
      margin: { t: 30, r: 20, b: 60, l: 70 },
      xaxis: {
        title: 'Employment rate (%)',
        ticksuffix: '%',
        zeroline: false,
        range: xRange,
        fixedrange: true
      },
      yaxis: {
        title: 'Net monthly wage (EUR)',
        zeroline: false,
        range: yRange,
        fixedrange: true
      },
      hovermode: 'closest',
      legend: {
        x: 0.02,
        y: 0.98,
        xanchor: 'left',
        yanchor: 'top',
        bgcolor: 'rgba(255,255,255,0.8)',
        bordercolor: 'rgba(0,0,0,0.12)',
        borderwidth: 1
      }
    };

    const config = {
      responsive: true,
      displayModeBar: false,
      scrollZoom: false,
      doubleClick: false,
      displaylogo: false
    };

    Plotly.newPlot(chart, traces, layout, config);
  } catch (error) {
    chart.textContent = 'Chart data could not be loaded.';
    console.error(error);
  }
});
</script>
