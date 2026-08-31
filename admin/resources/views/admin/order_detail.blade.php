@extends('admin.layouts.app')

@section('content')
<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 16px; flex-wrap:wrap; gap:12px;">
    <a href="{{ route('admin.orders') }}" style="color:var(--blue); font-weight:600; display:inline-flex; align-items:center; gap:6px;">
        &larr; Back to All Orders
    </a>

    <a href="{{ route('admin.orders.print', $order->id) }}" target="_blank" class="btn-sm" style="background:var(--blue); color:#fff; padding:8px 16px; border-radius:8px; font-weight:600; text-decoration:none; display:inline-flex; align-items:center; gap:8px;">
        <span>🖨️ Print / A4 Sheet View</span>
    </a>
</div>

<div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));">
    <div class="stat-card">
        <h3>Order Information</h3>
        <div style="font-size: 20px; font-weight: 700; color: var(--text); margin: 6px 0;">
            {{ $order->order_number }}
        </div>
        <div style="color: var(--muted); font-size: 13px;">Placed: {{ $order->created_at ? $order->created_at->format('d M Y, h:i A') : '—' }}</div>
        <div class="hint" style="margin-top: 8px;">
            @php
                $badge = match ($order->status) {
                    'paid' => 'badge-green',
                    'delivered' => 'badge-green',
                    'created' => 'badge-orange',
                    default => 'badge-gray',
                };
            @endphp
            Status: <span class="badge {{ $badge }}">{{ ucfirst($order->status) }}</span>
        </div>
    </div>

    <div class="stat-card">
        <h3>Customer Details</h3>
        @if ($order->user)
            <div style="font-size: 16px; font-weight: 700; color: var(--text); margin: 6px 0;">
                <a href="{{ route('admin.users.show', $order->user->id) }}" style="color:var(--blue)">
                    {{ $order->user->name ?: 'Customer' }}
                </a>
            </div>
            <div style="color: var(--muted); font-size: 13px;">{{ $order->user->email }}</div>
            <div class="hint" style="margin-top: 8px;">User ID: #{{ $order->user->id }}</div>
        @else
            <div style="color: var(--muted); margin: 6px 0;">Guest Customer</div>
        @endif
    </div>

    <div class="stat-card">
        <h3>Payment Info</h3>
        <div class="value" style="color:var(--green)">₹{{ number_format($order->subtotal) }}</div>
        <div style="font-size: 11px; color: var(--muted); font-family: monospace; margin-top: 4px;">
            Razorpay Order: {{ $order->razorpay_order_id }}
        </div>
        <div style="font-size: 11px; color: var(--muted); font-family: monospace; margin-top: 2px;">
            Payment ID: {{ $order->razorpay_payment_id ?? 'Pending' }}
        </div>
    </div>
</div>

@php
    $items = is_array($order->items) ? $order->items : json_decode($order->items, true) ?? [];
@endphp

{{-- Visual Cards Grid with Exact Front & Back Previews --}}
<div class="panel" style="margin-top: 20px;">
    <div class="panel-head">
        <div>
            <h3 style="margin:0;">Customized Templates in this Order (Front & Back HD View)</h3>
            <span style="font-size:12px; color:var(--muted);">All {{ count($items) }} exact original templates created by the user</span>
        </div>
        <a href="{{ route('admin.orders.print', $order->id) }}" target="_blank" style="color:var(--blue); font-weight:600; font-size:13px;">
            Open A4 Printable Sheet &rarr;
        </a>
    </div>

    <div style="padding: 20px; display:grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 24px;">
        @foreach ($items as $idx => $item)
            @php
                $titleParts = explode('·', $item['design_title'] ?? '');
                $instName = trim($item['institute_name'] ?? ($titleParts[0] ?? 'Institution'));
                $studName = trim($item['student_name'] ?? ($titleParts[1] ?? ($titleParts[0] ?? 'Card Member')));
                
                // Match saved card if available
                $matchedCard = $userCards->first(function($c) use ($studName, $instName) {
                    return stripos($c->student_name, $studName) !== false || stripos($c->title, $studName) !== false;
                });

                $frontImage = $item['front_image'] ?? ($matchedCard ? $matchedCard->front_path : null);
                $backImage = $item['back_image'] ?? ($matchedCard ? $matchedCard->back_path : null);

                // Helper to resolve URL
                $resolveUrl = function($path) {
                    if (empty($path)) return null;
                    if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) return $path;
                    if (str_starts_with($path, 'uploads/')) return asset($path);
                    return null;
                };

                $frontUrl = $resolveUrl($frontImage);
                $backUrl = $resolveUrl($backImage);
            @endphp
            <div style="background: #ffffff; border: 1px solid var(--border); border-radius: 14px; overflow:hidden; box-shadow: 0 4px 14px rgba(0,0,0,0.05); display:flex; flex-direction:column;">
                {{-- Card Header --}}
                <div style="background: linear-gradient(135deg, #1e3a8a, #2563eb); color:#ffffff; padding: 14px 18px; display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        <div style="font-size:10px; text-transform:uppercase; letter-spacing:0.06em; opacity:0.85;">ITEM #{{ $idx + 1 }} · {{ $item['product_name'] ?? 'ID CARD' }}</div>
                        <div style="font-size:15px; font-weight:700; margin-top:2px;">{{ $studName }}</div>
                        <div style="font-size:12px; opacity:0.9;">{{ $instName }}</div>
                    </div>
                    <span style="background:rgba(255,255,255,0.2); padding:4px 10px; border-radius:20px; font-size:11px; font-weight:600;">
                        Size: {{ $item['size'] ?? 'Standard' }}
                    </span>
                </div>

                {{-- Card Images Section (Front & Back) --}}
                <div style="padding: 16px; background:#f8fafc; flex:1;">
                    <div style="display:grid; grid-template-columns: {{ $backUrl ? '1fr 1fr' : '1fr' }}; gap: 12px;">
                        {{-- Front Image --}}
                        <div style="background:#ffffff; border:1px solid #e2e8f0; border-radius:10px; padding:10px; text-align:center;">
                            <div style="font-size:11px; font-weight:700; color:#3b82f6; text-transform:uppercase; margin-bottom:8px;">
                                🪪 Front View
                            </div>
                            @if ($frontUrl)
                                <a href="{{ $frontUrl }}" target="_blank" title="Click to open Full HD Front Image">
                                    <img src="{{ $frontUrl }}" alt="Front View" style="width:100%; max-height:240px; object-fit:contain; border-radius:6px; box-shadow:0 2px 6px rgba(0,0,0,0.08); transition:transform 0.2s;" onmouseover="this.style.transform='scale(1.02)'" onmouseout="this.style.transform='scale(1)'" />
                                </a>
                                <div style="margin-top:8px;">
                                    <a href="{{ $frontUrl }}" target="_blank" style="font-size:11px; color:var(--blue); font-weight:600; text-decoration:underline;">
                                        🔍 View HD Front &nearr;
                                    </a>
                                </div>
                            @else
                                {{-- Realistic Template Card Mockup when image is not present in old legacy orders --}}
                                <div style="background:linear-gradient(180deg, #1e3a8a 0%, #1e40af 35%, #ffffff 35%, #ffffff 100%); border:1px solid #cbd5e1; border-radius:8px; padding:12px; box-shadow:0 2px 8px rgba(0,0,0,0.06); text-align:center;">
                                    <div style="color:#ffffff; font-size:11px; font-weight:700; text-transform:uppercase; height:32px; display:flex; align-items:center; justify-content:center;">
                                        {{ $instName }}
                                    </div>
                                    <div style="width:54px; height:62px; background:#e2e8f0; border:2px solid #ffffff; border-radius:6px; margin:8px auto 6px auto; display:flex; align-items:center; justify-content:center; color:#475569; font-weight:700; font-size:20px; box-shadow:0 2px 4px rgba(0,0,0,0.1);">
                                        {{ strtoupper(substr($studName, 0, 1)) }}
                                    </div>
                                    <div style="font-size:13px; font-weight:700; color:#0f172a;">{{ $studName }}</div>
                                    <div style="font-size:10px; color:#64748b; margin-top:2px;">STUDENT / MEMBER</div>
                                    <div style="margin-top:8px; border-top:1px dashed #cbd5e1; padding-top:6px; font-size:9px; color:#64748b; display:flex; justify-content:space-between;">
                                        <span>Roll No: <strong>01</strong></span>
                                        <span>Size: <strong>{{ $item['size'] ?? 'Standard' }}</strong></span>
                                    </div>
                                </div>
                            @endif
                        </div>

                        {{-- Back Image --}}
                        @if ($backUrl)
                            <div style="background:#ffffff; border:1px solid #e2e8f0; border-radius:10px; padding:10px; text-align:center;">
                                <div style="font-size:11px; font-weight:700; color:#10b981; text-transform:uppercase; margin-bottom:8px;">
                                    🔄 Back View
                                </div>
                                <a href="{{ $backUrl }}" target="_blank" title="Click to open Full HD Back Image">
                                    <img src="{{ $backUrl }}" alt="Back View" style="width:100%; max-height:240px; object-fit:contain; border-radius:6px; box-shadow:0 2px 6px rgba(0,0,0,0.08); transition:transform 0.2s;" onmouseover="this.style.transform='scale(1.02)'" onmouseout="this.style.transform='scale(1)'" />
                                </a>
                                <div style="margin-top:8px;">
                                    <a href="{{ $backUrl }}" target="_blank" style="font-size:11px; color:var(--green); font-weight:600; text-decoration:underline;">
                                        🔍 View HD Back &nearr;
                                    </a>
                                </div>
                            </div>
                        @endif
                    </div>

                    {{-- Meta breakdown --}}
                    <div style="margin-top:14px; background:#ffffff; border-radius:8px; border:1px solid #e2e8f0; padding:10px 14px; display:flex; justify-content:space-between; font-size:12px;">
                        <span>Quantity: <strong>{{ $item['quantity'] ?? 1 }}</strong></span>
                        <span>Unit: <strong>₹{{ number_format($item['unit_price'] ?? 25) }}</strong></span>
                        <span>Total: <strong style="color:var(--blue)">₹{{ number_format($item['line_total'] ?? 25) }}</strong></span>
                    </div>
                </div>
            </div>
        @endforeach
    </div>
</div>

{{-- Itemized Table --}}
<div class="panel" style="margin-top: 20px;">
    <div class="panel-head">
        <h3>Order Items Breakdown</h3>
        <span>{{ $order->total_qty }} total items</span>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Product</th>
                <th>Customized Name / Design Title</th>
                <th>Size</th>
                <th>Unit Price</th>
                <th>Quantity</th>
                <th>Line Total</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($items as $idx => $item)
                <tr>
                    <td>{{ $idx + 1 }}</td>
                    <td><strong>{{ $item['product_name'] ?? 'ID CARD' }}</strong></td>
                    <td><strong>{{ $item['design_title'] ?? 'Custom Design' }}</strong></td>
                    <td><span class="badge badge-blue">{{ $item['size'] ?? 'Standard' }}</span></td>
                    <td>₹{{ number_format($item['unit_price'] ?? 0) }}</td>
                    <td>{{ $item['quantity'] ?? 1 }}</td>
                    <td><strong>₹{{ number_format($item['line_total'] ?? 0) }}</strong></td>
                </tr>
            @empty
                <tr>
                    <td colspan="7" style="text-align:center; padding: 24px; color:var(--muted)">
                        No item details found.
                    </td>
                </tr>
            @endforelse
        </tbody>
    </table>

    <div style="display:flex; justify-content:flex-end; padding: 16px 20px; border-top: 1px solid var(--border);">
        <div style="text-align:right;">
            <div style="font-size:14px; color:var(--muted)">Subtotal: <strong>₹{{ number_format($order->subtotal) }}</strong></div>
            <div style="font-size:18px; font-weight:700; color:var(--text); margin-top:4px;">
                Grand Total: <span style="color:var(--blue)">₹{{ number_format($order->subtotal) }}</span>
            </div>
        </div>
    </div>
</div>
@endsection
