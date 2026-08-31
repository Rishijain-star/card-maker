<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>A4 Print Sheet — {{ $order->order_number }} (8 Cards / Page)</title>
    <style>
        @page {
            size: A4 portrait;
            margin: 6mm 8mm;
        }
        * {
            box-sizing: border-box;
            -webkit-print-color-adjust: exact !important;
            print-color-adjust: exact !important;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background: #e2e8f0;
            color: #0f172a;
            margin: 0;
            padding: 16px 0;
        }
        .no-print {
            background: #ffffff;
            max-width: 210mm;
            margin: 0 auto 16px auto;
            padding: 12px 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .btn {
            background: #2563eb;
            color: #ffffff;
            border: none;
            padding: 9px 18px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn:hover { background: #1d4ed8; }
        .btn-outline {
            background: #f8fafc;
            color: #334155;
            border: 1px solid #cbd5e1;
        }

        /* A4 Page Container */
        .a4-page {
            background: #ffffff;
            width: 210mm;
            min-height: 297mm;
            margin: 0 auto 20px auto;
            padding: 8mm 8mm;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border-radius: 2px;
            page-break-after: always;
            position: relative;
        }
        .a4-page:last-child {
            page-break-after: avoid;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1.5px solid #0f172a;
            padding-bottom: 6px;
            margin-bottom: 8mm;
            font-size: 11px;
        }
        .page-header h1 {
            margin: 0;
            font-size: 15px;
            color: #0f172a;
            font-weight: 700;
        }
        .page-header span {
            color: #64748b;
        }

        /* 8 Cards Grid: Exactly 4 Horizontal Columns x 2 Vertical Rows */
        .cards-grid-8 {
            display: grid;
            grid-template-columns: repeat(4, 45.5mm);
            grid-template-rows: repeat(2, 72mm);
            gap: 6mm 4mm;
            justify-content: center;
        }

        .card-slot {
            width: 45.5mm;
            height: 72mm;
            border: 0.6px dashed #94a3b8;
            border-radius: 4px;
            overflow: hidden;
            background: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            page-break-inside: avoid;
        }

        .card-slot img {
            width: 100%;
            height: 100%;
            object-fit: fill;
            display: block;
        }

        .card-slot .cut-guide {
            position: absolute;
            top: 2px;
            right: 4px;
            font-size: 7px;
            color: #94a3b8;
            background: rgba(255,255,255,0.7);
            padding: 1px 3px;
            border-radius: 2px;
            pointer-events: none;
        }

        .page-footer {
            position: absolute;
            bottom: 6mm;
            left: 8mm;
            right: 8mm;
            display: flex;
            justify-content: space-between;
            font-size: 9px;
            color: #94a3b8;
            border-top: 1px dotted #cbd5e1;
            padding-top: 4px;
        }

        @media print {
            body {
                background: #ffffff;
                padding: 0;
            }
            .no-print {
                display: none !important;
            }
            .a4-page {
                box-shadow: none;
                margin: 0;
                width: 100%;
                min-height: auto;
                padding: 4mm 6mm;
            }
        }
    </style>
</head>
<body>

<div class="no-print">
    <div>
        <a href="{{ route('admin.orders.show', $order->id) }}" class="btn btn-outline">
            &larr; Back to Order Details
        </a>
    </div>
    <div style="display:flex; gap:12px; align-items:center;">
        <span style="font-size:13px; color:#475569; font-weight:600;">
            Layout: <strong>8 Cards per A4 Sheet (4 Horizontal x 2 Rows)</strong>
        </span>
        <button onclick="window.print()" class="btn">
            <span>🖨️ Print Sheet / Save as PDF</span>
        </button>
    </div>
</div>

@php
    $items = is_array($order->items) ? $order->items : json_decode($order->items, true) ?? [];

    $resolveUrl = function($path) {
        if (empty($path)) return null;
        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) return $path;
        if (str_starts_with($path, 'uploads/')) return asset($path);
        return null;
    };

    // Flatten all card faces (Front and Back) to print in the 8-card grid
    $allCardImages = [];
    foreach ($items as $idx => $item) {
        $titleParts = explode('·', $item['design_title'] ?? '');
        $studName = trim($item['student_name'] ?? ($titleParts[1] ?? ($titleParts[0] ?? 'Card Member')));
        $instName = trim($item['institute_name'] ?? ($titleParts[0] ?? 'Institution'));

        $matchedCard = $userCards->first(function($c) use ($studName, $instName) {
            return stripos($c->student_name, $studName) !== false || stripos($c->title, $studName) !== false;
        });

        $frontImage = $item['front_image'] ?? ($matchedCard ? $matchedCard->front_path : null);
        $backImage = $item['back_image'] ?? ($matchedCard ? $matchedCard->back_path : null);

        $frontUrl = $resolveUrl($frontImage);
        $backUrl = $resolveUrl($backImage);

        // Add front
        if ($frontUrl) {
            $allCardImages[] = [
                'url' => $frontUrl,
                'label' => $studName . ' (Front)',
            ];
        } else {
            // Fallback placeholder with student details
            $allCardImages[] = [
                'url' => null,
                'stud_name' => $studName,
                'inst_name' => $instName,
                'label' => $studName,
            ];
        }

        // Add back if available
        if ($backUrl && $backUrl !== $frontUrl) {
            $allCardImages[] = [
                'url' => $backUrl,
                'label' => $studName . ' (Back)',
            ];
        }
    }

    // Chunk into pages of 8 cards each
    $pages = array_chunk($allCardImages, 8);
    if (empty($pages)) {
        $pages = [[]];
    }
@endphp

@foreach ($pages as $pageIndex => $cardsOnPage)
    <div class="a4-page">
        <div class="page-header">
            <div>
                <h1>{{ $company['name'] ?? 'ID-Shaydi Card Maker' }} — Print Sheet</h1>
                <span>Customer: <strong>{{ $order->user ? $order->user->name : 'Customer' }}</strong> ({{ $order->user ? $order->user->email : '' }})</span>
            </div>
            <div style="text-align:right;">
                <div>Order: <strong style="color:#2563eb">{{ $order->order_number }}</strong></div>
                <span>Page {{ $pageIndex + 1 }} of {{ count($pages) }}</span>
            </div>
        </div>

        <div class="cards-grid-8">
            @foreach ($cardsOnPage as $cardIdx => $card)
                <div class="card-slot">
                    @if (!empty($card['url']))
                        <img src="{{ $card['url'] }}" alt="{{ $card['label'] ?? 'ID Card' }}">
                    @else
                        <div style="width:100%; height:100%; display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; padding:8px; background:#f8fafc;">
                            <div style="font-size:9px; font-weight:700; color:#1e3a8a;">{{ $card['inst_name'] ?? 'ID CARD' }}</div>
                            <div style="width:28px; height:32px; background:#e2e8f0; border-radius:4px; margin:4px 0; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:700;">
                                {{ strtoupper(substr($card['stud_name'] ?? 'U', 0, 1)) }}
                            </div>
                            <div style="font-size:10px; font-weight:700; color:#0f172a;">{{ $card['stud_name'] ?? 'Student' }}</div>
                        </div>
                    @endif
                    <div class="cut-guide">✂️ #{{ ($pageIndex * 8) + $cardIdx + 1 }}</div>
                </div>
            @endforeach

            {{-- Fill empty slots up to 8 if needed --}}
            @for ($i = count($cardsOnPage); $i < 8; $i++)
                <div class="card-slot" style="border: 0.6px dashed #e2e8f0; background: transparent;"></div>
            @endfor
        </div>

        <div class="page-footer">
            <span>Order #{{ $order->order_number }} · Total Cards: {{ count($allCardImages) }}</span>
            <span>A4 Print Sheet (4x2 Grid) · ID-Shaydi</span>
        </div>
    </div>
@endforeach

</body>
</html>
