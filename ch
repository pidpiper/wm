<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>U.S. Waste Generation and Recycling</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            font-family: "Inter", "Inter Placeholder", sans-serif;
            font-size: 14px;
            line-height: 20px;
            color: rgb(102, 102, 102);
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
            overflow-y: auto;
        }

        #loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #f7f7f7;
            z-index: 1000;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: opacity 1s ease-out;
        }

        #loader.hidden {
            opacity: 0;
            pointer-events: none;
        }

        .animation-container {
            font-family: monospace;
            font-size: clamp(8px, 1.2vw, 12px);
            margin: 20px;
            line-height: 1;
        }

        @media (max-width: 768px) {
            .animation-container {
                font-size: clamp(6px, 0.8vw, 10px);
                transform: scale(0.8);
            }
        }

        #animation {
            white-space: pre;
        }

        .character {
            display: inline-block;
            padding: 0;
            margin: 0;
        }

        .content {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            padding: 5rem 1rem 2rem;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            min-height: 100%;
            opacity: 0;
            transition: opacity 0.5s ease-in;
        }

        .content.visible {
            opacity: 1;
        }

        .content.hidden {
            display: none;
        }

        .container {
            max-width: 600px;
            width: 100%;
            padding-right: 2rem;
        }

        h1 {
            margin-bottom: 5px;
            font-size: 16px;
            font-weight: 600;
            color: rgb(102, 102, 102);
            font-family: "Times New Roman", Times, serif;
        }

        p {
            margin-bottom: 24px;
            margin-top: 0;
        }

        a {
            color: rgb(90, 90, 90);
            text-decoration-line: underline;
            text-decoration-color: #696969;
            transition: opacity 0.2s ease;
        }

        a:hover {
            opacity: 0.6;
        }

        hr {
            border: none;
            border-top: 1px solid #EAEAEA;
            margin: 24px 0 16px;
        }

        .chart-container {
            position: relative;
            width: 100%;
            height: 400px;
            margin-bottom: 24px;
        }

        canvas {
            width: 100% !important;
            height: 100% !important;
        }

        .footnote {
            font-size: 12px;
            color: rgb(102, 102, 102);
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="content visible">
        <div class="container">
            <h1>U.S. Waste Generation and Recycling (1960-2025)</h1>
            <div class="chart-container">
                <canvas id="wasteChart"></canvas>
            </div>
            <div class="footnote">*2020 and 2025 values are projections based on a 1.55% average growth rate over 5-year intervals.</div>
        </div>
    </div>

    <script>
        // Years (X-Axis) with asterisks for projections
        const years = [1960, 1965, 1970, 1975, 1980, 1985, 1990, 1995, 2000, 2005, 2010, 2015, "2020*", "2025*"];

        // Waste data (in million tons)
        const landfillData = [82.51, 97.55, 112.59, 123.47, 134.36, 139.82, 145.27, 142.76, 140.26, 142.29, 136.31, 137.61, 147.28, 149.49];
        const recyclingData = [5.61, 6.82, 8.02, 11.27, 14.52, 21.78, 29.04, 41.03, 53.01, 59.24, 65.26, 67.56, 74.65, 90.22];
        const totalWasteData = [88.12, 104.37, 120.61, 134.74, 148.88, 161.60, 174.31, 183.79, 193.27, 201.53, 201.57, 205.17, 221.93, 239.71];

        // Get canvas context
        const ctx = document.getElementById('wasteChart').getContext('2d');

        // Create the chart
        const wasteChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: years,
                datasets: [
                    {
                        label: 'Landfill',
                        data: landfillData,
                        backgroundColor: 'rgba(200, 200, 200, 0)', // Light gray fill (corrected from your last code)
                        borderColor: 'rgba(100, 102, 100, 0.8)', // Border color (will be overridden)
                        borderWidth: 0, // No stroke for landfill
                        fill: true, // Fill from bottom
                        tension: 0.3
                    },
                    {
                        label: 'Recycling',
                        data: recyclingData,
                        backgroundColor: 'rgba(50, 150, 50, 0.7)', // Green for recycling
                        borderColor: 'rgba(0, 100, 0, 1)', // Dark green border
                        fill: true, // Fill from bottom
                        tension: 0.3
                    },
                    {
                        label: 'Total Waste',
                        data: totalWasteData,
                        backgroundColor: 'rgba(102, 102, 102, 0.2)', // Subtle gray fill
                        borderColor: 'rgba(102, 102, 102, 0.8)', // Gray border
                        borderWidth: 2,
                        fill: true, // Shaded from bottom
                        tension: 0.3,
                        pointRadius: 0 // No points for cleaner look
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        padding: { top: 0, bottom: 15 },
                        color: 'rgb(102, 102, 102)'
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: false,
                        callbacks: {
                            label: function(context) {
                                return `${context.dataset.label}: ${context.raw.toFixed(2)} million tons`;
                            }
                        }
                    },
                    legend: {
                        position: 'bottom',
                        align: 'start', // Align to the left
                        labels: {
                            font: { size: 14 },
                            padding: 10,
                            color: 'rgb(102, 102, 102)',
                            filter: function(legendItem, chartData) {
                                // Exclude 'Landfill' from the legend
                                return legendItem.text !== 'Landfill';
                            }
                        },
                        padding: 10,
                        boxWidth: 20,
                        boxHeight: 10
                    }
                },
                scales: {
                    y: {
                        stacked: false, // Disable stacking since all fill from bottom
                        beginAtZero: true,
                        title: { 
                            display: true, 
                            text: 'Million Tons', 
                            font: { size: 14, weight: 'bold', color: 'rgb(102, 102, 102)' }
                        },
                        ticks: { font: { size: 14, color: 'rgb(102, 102, 102)' } },
                        grid: { 
                            borderDash: [5, 5], 
                            color: 'rgba(0, 0, 0, 0.1)',
                            drawOnChartArea: true, // Keep horizontal
                            drawTicks: false // Remove vertical gridlines
                        }
                    },
                    x: {
                        title: { 
                            display: true, 
                            text: 'Year', 
                            font: { size: 14, weight: 'bold', color: 'rgb(102, 102, 102)' }
                        },
                        ticks: { font: { size: 14, color: 'rgb(102, 102, 102)' } },
                        grid: { 
                            display: false // Remove vertical gridlines
                        }
                    }
                },
                elements: {
                    line: { borderWidth: 1 }, // Default, overridden for Landfill
                    point: { radius: 0 }
                },
                layout: {
                    padding: { left: 0, right: 0, top: 0, bottom: 20 }
                }
            }
        });
    </script>
</body>
</html>

