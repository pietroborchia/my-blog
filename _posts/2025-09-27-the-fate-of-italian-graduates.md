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

<div id="aggregate-timeseries" style="width:100%;height:620px"></div>
<p class="chart-caption">Aggregate employment rate and wage over time for graduates 5 years after graduation. Solid lines show the mean across available AlmaLaurea series; shaded areas show the interquartile range (Source: AlmaLaurea, 2024).</p>

<div id="eurostat-wage-comparison" style="width:100%;height:480px"></div>
<p class="chart-caption">Median hourly earnings over time in selected European countries (Eurostat SES, employees in enterprises with 10 or more employees, NACE B-S excluding public administration).</p>

<!-- Papa Parse: robust CSV parser in the browser -->
<script defer src="https://cdn.jsdelivr.net/npm/papaparse@5.4.1/papaparse.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', async () => {
  const chart = document.getElementById('graduates-scatter');
  let scatterPlotted = false;
  let aggregatePlotted = false;

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
    scatterPlotted = true;

    const timeSeriesUrl = "{{ '/data/27-09-2025/almalaurea_aggregate_timeseries.csv' | relative_url }}";
    const timeSeriesRes = await fetch(timeSeriesUrl);
    if (!timeSeriesRes.ok) throw new Error(`Could not load ${timeSeriesUrl}`);
    const timeSeriesText = await timeSeriesRes.text();
    const timeSeriesRows = Papa.parse(timeSeriesText, { header: true, dynamicTyping: true }).data
      .filter(r => r.Metric && r.Year && r.Value != null && String(r.Series).endsWith('5'));

    const quantile = (values, p) => {
      const sorted = [...values].sort((a, b) => a - b);
      const pos = (sorted.length - 1) * p;
      const base = Math.floor(pos);
      const rest = pos - base;
      return sorted[base + 1] === undefined
        ? sorted[base]
        : sorted[base] + rest * (sorted[base + 1] - sorted[base]);
    };

    const summarizeMetric = metric => {
      const byYear = new Map();
      timeSeriesRows
        .filter(r => r.Metric === metric)
        .forEach(r => {
          if (!byYear.has(r.Year)) byYear.set(r.Year, []);
          byYear.get(r.Year).push(r.Value);
        });

      return [...byYear.entries()]
        .sort(([a], [b]) => a - b)
        .map(([year, values]) => ({
          year,
          mean: values.reduce((sum, value) => sum + value, 0) / values.length,
          q1: quantile(values, 0.25),
          q3: quantile(values, 0.75)
        }));
    };

    const buildBandTraces = ({ data, name, axis, color, hoverSuffix }) => [
      {
        type: 'scatter',
        x: data.map(d => d.year),
        y: data.map(d => d.q3),
        mode: 'lines',
        line: { width: 0 },
        hoverinfo: 'skip',
        showlegend: false,
        xaxis: axis.x,
        yaxis: axis.y
      },
      {
        type: 'scatter',
        x: data.map(d => d.year),
        y: data.map(d => d.q1),
        mode: 'lines',
        fill: 'tonexty',
        fillcolor: color.band,
        line: { width: 0 },
        name: `${name} IQR`,
        hoverinfo: 'skip',
        xaxis: axis.x,
        yaxis: axis.y
      },
      {
        type: 'scatter',
        x: data.map(d => d.year),
        y: data.map(d => d.mean),
        mode: 'lines+markers',
        name: `${name} mean`,
        line: { color: color.line, width: 2 },
        marker: { size: 5 },
        hovertemplate: `${name}<br>%{x}<br>Mean: %{y:.1f}${hoverSuffix}<extra></extra>`,
        xaxis: axis.x,
        yaxis: axis.y
      }
    ];

    const employmentSummary = summarizeMetric('employment_rate');
    const wageSummary = summarizeMetric('wage_eur');
    const aggregateTraces = [
      ...buildBandTraces({
        data: employmentSummary,
        name: 'Employment rate',
        axis: { x: 'x', y: 'y' },
        color: { line: '#2563eb', band: 'rgba(37,99,235,0.18)' },
        hoverSuffix: '%'
      }),
      ...buildBandTraces({
        data: wageSummary,
        name: 'Net monthly wage',
        axis: { x: 'x2', y: 'y2' },
        color: { line: '#059669', band: 'rgba(5,150,105,0.18)' },
        hoverSuffix: ' EUR'
      })
    ];

    Plotly.newPlot('aggregate-timeseries', aggregateTraces, {
      grid: { rows: 2, columns: 1, pattern: 'independent' },
      margin: { t: 20, r: 20, b: 50, l: 70 },
      xaxis: { fixedrange: true },
      yaxis: {
        title: 'Employment rate (%)',
        ticksuffix: '%',
        fixedrange: true,
        domain: [0.56, 1]
      },
      xaxis2: {
        title: 'Year of survey',
        fixedrange: true,
        domain: [0, 1]
      },
      yaxis2: {
        title: 'Net monthly wage (EUR)',
        fixedrange: true,
        domain: [0, 0.44]
      },
      hovermode: 'x unified',
      legend: {
        x: 0.02,
        y: 0.98,
        xanchor: 'left',
        yanchor: 'top',
        bgcolor: 'rgba(255,255,255,0.8)',
        bordercolor: 'rgba(0,0,0,0.12)',
        borderwidth: 1
      }
    }, config);
    aggregatePlotted = true;

    const wageComparisonUrl = "{{ '/data/27-09-2025/eurostat_ses_median_hourly_earnings.csv' | relative_url }}";
    const wageComparisonRes = await fetch(wageComparisonUrl);
    if (!wageComparisonRes.ok) throw new Error(`Could not load ${wageComparisonUrl}`);
    const wageComparisonText = await wageComparisonRes.text();
    const wageComparisonRows = Papa.parse(wageComparisonText, { header: true, dynamicTyping: true }).data
      .filter(r => r.Country && r.Year && r['Median hourly earnings (EUR)'] != null);

    const countries = [...new Set(wageComparisonRows.map(r => r.Country))];
    const wageComparisonTraces = countries.map(country => {
      const rows = wageComparisonRows
        .filter(r => r.Country === country)
        .sort((a, b) => a.Year - b.Year);

      return {
        type: 'scatter',
        mode: 'lines+markers',
        name: country,
        x: rows.map(r => r.Year),
        y: rows.map(r => r['Median hourly earnings (EUR)']),
        hovertemplate: `${country}<br>%{x}<br>Median hourly earnings: EUR %{y:.2f}<extra></extra>`
      };
    });

    Plotly.newPlot('eurostat-wage-comparison', wageComparisonTraces, {
      margin: { t: 20, r: 20, b: 55, l: 70 },
      xaxis: {
        title: 'Year',
        fixedrange: true
      },
      yaxis: {
        title: 'Median hourly earnings (EUR)',
        fixedrange: true
      },
      hovermode: 'x unified',
      legend: {
        x: 0.02,
        y: 0.98,
        xanchor: 'left',
        yanchor: 'top',
        bgcolor: 'rgba(255,255,255,0.8)',
        bordercolor: 'rgba(0,0,0,0.12)',
        borderwidth: 1
      }
    }, config);
  } catch (error) {
    if (!scatterPlotted) chart.textContent = 'Chart data could not be loaded.';
    const aggregateChart = document.getElementById('aggregate-timeseries');
    if (aggregateChart && !aggregatePlotted) aggregateChart.textContent = 'Chart data could not be loaded.';
    const wageComparisonChart = document.getElementById('eurostat-wage-comparison');
    if (wageComparisonChart) wageComparisonChart.textContent = 'Chart data could not be loaded.';
    console.error(error);
  }
});
</script>
