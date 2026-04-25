---
layout: default
title: "The fate of Italian graduates"
summary: "An analysis of employment rates and earnings of Italian graduates."
plotly: true
---

A country's prime asset is its talent: the capable people who drive innovation and productivity. Today, that mostly requires deep specialisation in technical fields and an industrial fabric able to absorb those skills and remunerate them fairly. Building such a workforce does not happen spontaneously; it depends on well-structured policies for secondary and tertiary education and credible industrial planning. Italy struggles on both counts, and the gravity of this failure is evident in two indicators for recent graduates: employment rates and salaries. <br>
In this post I examine, through the numbers, the troubling outcomes facing Italy's early-career cohorts on these two metrics. First, I map the distribution of results across fields of study; then I compare Italy's performance with other OECD countries.

<div class="chart-wide chart-grid">
  <div id="graduates-scatter-1yr" class="chart-panel"></div>
  <div id="graduates-scatter-5yr" class="chart-panel"></div>
</div>
<p class="chart-caption">Employment rate vs. net monthly wage for graduates 1 and 5 years after graduation (Source: AlmaLaurea, 2024).</p>

<!-- Papa Parse: robust CSV parser in the browser -->
<script defer src="https://cdn.jsdelivr.net/npm/papaparse@5.4.1/papaparse.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', async () => {
  const charts = {
    '1 year': document.getElementById('graduates-scatter-1yr'),
    '5 years': document.getElementById('graduates-scatter-5yr')
  };

  // Build a base-aware URL for GitHub Pages
  const datasets = [
    {
      name: '1 year',
      url: "{{ '/data/27-09-2025/graduates_stats_1yr.csv' | relative_url }}",
      title: '1 year after graduation'
    },
    {
      name: '5 years',
      url: "{{ '/data/27-09-2025/graduates_stats_5yr.csv' | relative_url }}",
      title: '5 years after graduation'
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

    const makeTrace = dataset => {
      const x = dataset.rows.map(r => r['Employment rate (%)']);
      const y = dataset.rows.map(r => r['Net monthly wage (EUR)']);
      const labels = dataset.rows.map(r => r['Field of study']);

      return {
        type: 'scatter',
        mode: 'markers',
        showlegend: false,
        x, y,
        text: labels,
        hovertemplate:
          `${dataset.name}<br>%{text}<br>Employment: %{x:.1f}%<br>Wage: EUR %{y:.0f}<extra></extra>`,
        marker: { size: 8, opacity: 0.85 },
        cliponaxis: false
      };
    };

    const makeLayout = dataset => ({
      title: {
        text: dataset.title,
        font: { size: 15 }
      },
      margin: { t: 45, r: 20, b: 55, l: 65 },
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
      hovermode: 'closest'
    });

    const config = {
      responsive: true,
      displayModeBar: false,
      scrollZoom: false,
      doubleClick: false,
      displaylogo: false
    };

    series.forEach(dataset => {
      Plotly.newPlot(charts[dataset.name], [makeTrace(dataset)], makeLayout(dataset), config);
    });
  } catch (error) {
    Object.values(charts).forEach(chart => {
      if (chart) chart.textContent = 'Chart data could not be loaded.';
    });
    console.error(error);
  }
});
</script>
